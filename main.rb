#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'digest/md5'

host, port, channel, message, repo = ARGV
params = { 'channel' => "##{channel}" }

magic_number = Digest::MD5.hexdigest(repo).gsub(/[^0-9]/, '').split('').last.to_i
number = "%02d" % (5..14).to_a[magic_number]

colored_message = message.
  gsub(/(^.*):/, "\x03#{number}\\1\x0f:").
  gsub(/(build)/, "\x02\\1\x0f").
  gsub(/(deploy)/, "\x0302\\1\x0f").
  gsub(/(failed)/, "\x0304\\1\x0f").
  gsub(/(passed)/, "\x0303\\1\x0f")

uri = URI("http://#{host}:#{port}/join")
http = Net::HTTP.new(uri.host, uri.port)
req = Net::HTTP::Post.new(uri.path)
req.form_data = params
http.request(req)

uri = URI("http://#{host}:#{port}/notice")
http = Net::HTTP.new(uri.host, uri.port)
req = Net::HTTP::Post.new(uri.path)
req.form_data = params.merge('message' => colored_message)
http.request(req)
