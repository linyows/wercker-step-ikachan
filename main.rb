#!/usr/bin/env ruby

require 'net/http'
require 'uri'

host, port, channel, message = ARGV
params = { 'channel' => "##{channel}" }

colored_message = message.gsub(/(Wercker \(.*\):)/, "\x0308\\1\x0f").
  gsub(/(build)/, "\x02\\1\x0f").
  gsub(/(deploy)/, "\x0302\\1\x0f").
  gsub(/(failed)\./, "\x0304\\1\x0f").
  gsub(/(passed)\./, "\x0303\\1\x0f")

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
