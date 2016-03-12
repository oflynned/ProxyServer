require 'socket'
require 'uri'
require 'open-uri'
require 'fileutils'

#own classes
require 'require_all'
require_all 'modules'

#host definitions
host = 'localhost'
port = 2345

Helpers.module_initialization

allow = Allow.new
block = Block.new
cache = Cache.new
http = HTTP.new
https = HTTPS.new
manage = Manage.new
pool = Pool.new
server = TCPServer.new(host, port)

Helpers.initialisation_preamble

loop do
	socket = server.accept
	request = socket.gets
	url = Helpers.get_url(request).strip
	type = Helpers.retrieve_type(url)
	
	if !request.nil?
	  if type.eql? 'http'
	    puts "HTTP request filtered" 
	    if block.check_url(url)
	      puts "Request to " + url + " has been blacklisted!"
	      block.block_req(socket)
	    else
	      puts "Request to " + url + " has been whitelisted!"
	      allow.retrieve_page(request, socket)
	    end
	  elsif type.eql? 'https'
	    puts "HTTPS request"
	  else
	    puts "Neither HTTP nor HTTPS request"
	  end
	end
	
  socket.close
end
