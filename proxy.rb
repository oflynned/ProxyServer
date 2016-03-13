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
pool = Pool.new
@server = TCPServer.new(host, port)
superuser = Superuser.new

Helpers.initialisation_preamble

loop do
	socket = @server.accept
	request = socket.gets
	url = Helpers.url(request)
	type = Helpers.retrieve_type(url)
	verb = Helpers.verb(request)
	version = Helpers.version(request)
	folder_name = Helpers.splice_url(Helpers.get_url(request))
	raw_name = Helpers.retrieve_stripped(folder_name)
	
	if !request.nil?
	  if verb.eql? 'GET'
	    puts 'get req'
	  elsif verb.eql 'POST'
	    puts 'post req'
	  elsif verb.eql 'CONNECT'
	    puts 'connect req'
	  end
	  
	  is_blocked = block.check_url(url) or block.check_req(raw_name)
	  
	  if type.eql? 'http'
	    puts "HTTP request filtered" 
	    if is_blocked
	      puts "\nRequest to " + url + " has been blacklisted!\n"
	    else
	      puts "\nRequest to " + url + " has been whitelisted!\n"
	    end
	    pool.pool_conn(block, allow, is_blocked, request, socket)
	  elsif type.eql? 'https'
	    puts "HTTPS request"
	  else
	    puts "Neither HTTP nor HTTPS request"
	  end
	end
	
  socket.close
end
