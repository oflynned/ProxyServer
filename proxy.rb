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
	folder_name = Helpers.splice_url(url)
	raw_name = Helpers.retrieve_stripped(folder_name)
	
	if !request.nil?
	  if type.eql? 'http'
	    puts "HTTP request filtered" 
	    if block.check_url(url) or block.check_req(raw_name)
	      puts "\nRequest to " + url + " has been blacklisted!\n"
	      block.block_req(request, socket)
	    else
	      puts "\nRequest to " + url + " has been whitelisted!\n"
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
