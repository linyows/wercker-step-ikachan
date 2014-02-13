#!/usr/bin/env ruby

require 'net/http'
require 'uri'

host, port, channel, message = ARGV
params = { 'channel' => "##{channel}" }

uri = URI("http://#{host}:#{port}/join")
http = Net::HTTP.new(uri.host, uri.port)
req = Net::HTTP::Post.new(uri.path)
req.form_data = params
http.request(req)

uri = URI("http://#{host}:#{port}/notice")
http = Net::HTTP.new(uri.host, uri.port)
req = Net::HTTP::Post.new(uri.path)
req.form_data = params.merge('message' => message)
http.request(req)
