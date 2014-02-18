#!/usr/bin/env ruby

require 'net/http'
require 'net/https'
require 'uri'
require 'digest/md5'
require 'json'
require 'optparse'

argv = {}
OptionParser.new do |parser|
  parser.instance_eval do
    separator 'arguments:'
    on('-h VALUE', '--host', 'ikachan host') { |v| argv[:host] = v }
    on('-p VALUE', '--port', 'ikachan port') { |v| argv[:port] = v }
    on('-c VALUE', '--channel', 'irc channel') { |v| argv[:channel] = v }
    on('-r VALUE', '--repository', 'project repository name') { |v| argv[:repo] = v }
    on('-u VALUE', '--username', 'username') { |v| argv[:user] = v }
    on('-l VALUE', '--link', 'job url') { |v| argv[:job_url] = v }
    on('-t VALUE', '--target', 'job target') { |v| argv[:job_target] = v }
    on('-j VALUE', '--type', 'job type') { |v| argv[:job_type] = v }
    on('-s VALUE', '--status', 'job status') { |v| argv[:result] = v }
    on('-m [VALUE]', '--custom_message', 'custom message') { |v| argv[:custom_message] = v }
    parse!(ARGV)
  end
end

class String
  IRC_TEXT_COLOR  = "\x03"
  IRC_TEXT_BOLD   = "\x02"
  IRC_COLOR_CLEAR = "\x0f"
  IRC_COLOR_TABLE = {
     0 => 'white',
     1 => 'black',
     2 => 'blue',
     3 => 'green',
     4 => 'red',
     5 => 'brown',
     6 => 'purple',
     7 => 'orange',
     8 => 'yellow',
     9 => 'light_green',
    10 => 'teal',
    11 => 'cyan',
    12 => 'light_blue',
    13 => 'pink',
    14 => 'grey',
    15 => 'silver',
  }

  def colorize(color = nil)
    if color.nil?
      magic_number = Digest::MD5.hexdigest(self).
        gsub(/[^0-9]/, '').split('').last.to_i
      color_code = (5..14).to_a[magic_number]
    else
      color_table = IRC_COLOR_TABLE.invert
      return self unless color_table.has_key?(color)
      color_code = color_table[color]
    end
    "#{IRC_TEXT_COLOR}#{"%02d" % color_code}#{self}#{IRC_COLOR_CLEAR}"
  end

  def bold
    "#{IRC_TEXT_BOLD}#{self}#{IRC_COLOR_CLEAR}"
  end

  def shorten
    uri = URI('https://www.googleapis.com/urlshortener/v1/url')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    response = http.start do |ssl|
      request = Net::HTTP::Post.new uri.path
      request.content_type = 'application/json'
      request.body = { 'longUrl' => self }.to_json
      ssl.request(request)
    end

    JSON.parse(response.body)['id']
  rescue => e
    puts e.message
    self
  end
end

module Ikachan
  class << self
    def params
      { 'channel' => "##{@channel}" }
    end

    def http
      @http ||= Net::HTTP.new(@host, @port)
    end

    def join
      req = Net::HTTP::Post.new('/join')
      req.form_data = params
      http.request(req)
    end

    def notify
      req = Net::HTTP::Post.new('/notice')
      req.form_data = params.merge('message' => @built_message)
      http.request(req)
    end

    def build_message
      job = if @job_type == 'deploy'
          "#{'deploy'.bold} to #{@job_target}"
        else
          "#{'build'.bold} on #{@job_target}"
        end

      status = if @result == 'passed'
          'Successful'.to_s.colorize('green')
        else
          'Failed'.to_s.colorize('red')
        end

      url = "- #{@job_url.shorten}".colorize('blue')

      @built_message = if @custom_message == ''
          "#{@repo.to_s.colorize}: #{status} #{job} by #{@user} #{url}"
        else
          @custom_message
        end
    end

    def exec(argv)
      argv.each { |k, v| instance_variable_set(:"@#{k}", v) }
      self.build_message
      self.join
      self.notify
    end
  end
end

Ikachan.exec argv
