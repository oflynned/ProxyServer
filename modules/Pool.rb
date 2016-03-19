require 'socket'
require 'uri'
require 'thread'

class Pool
	MAX_THREADS = 32

  def initialize()
    @connections = 0
		@threads = Array.new(MAX_THREADS)
		
		@block = Block.new
		@allow = Allow.new
  end
  
  def pool_conn(socket)
	  @socket = socket.accept
	  thread = Thread.new(@socket) do |client_s|
	  	begin
				#request details	
				request = client_s.gets
				url = Helpers.url(request)
				uri = URI.parse(url)
				type = Helpers.retrieve_type(url)
				verb = Helpers.verb(request)
				version = Helpers.version(request)
				folder_name = Helpers.splice_url(Helpers.get_url(request))
				raw_name = Helpers.retrieve_stripped(folder_name)
				
	    	puts(verb + " " + url)
				return_to_client(uri, verb, version, request, client_s)
			end
		end
		@threads.push(thread)
  end
  
  def return_to_client(uri, verb, version, request, client_s)
    puts "Creating new connection in thread pool"
    @connections += 1
    puts "Connections in pool: #{@connections}"
    puts request
    @req_uri = request
		
		#check blacklist first
		if not request.nil?
			if verb.eql? 'GET'
				puts 'get req'
			elsif verb.eql 'POST'
				puts 'post req'
			elsif verb.eql 'CONNECT'
			  puts 'connect req'
			end
			
			server_s = TCPSocket.new(uri.host, (uri.port.nil? ? HTTP_PORT : uri.port))
			puts "#{verb} #{uri.path}?#{uri.query} HTTP/#{version}\r\n"
			server_s.write("#{verb} #{uri.path}?#{uri.query} HTTP/#{version}\r\n")
			is_blocked = Helpers.read_blacklist.include? "#{uri}"

			if verb.eql? "GET" or verb.eql? "POST"
			  puts "HTTP request filtered" 
			  if is_blocked
			    puts "Request to #{uri} has been blacklisted!"
			    @block.block_req(@req_uri, client_s)
			  else  
			    puts "Request to #{uri} has been whitelisted!"
			    @allow.retrieve_page(server_s, client_s, uri, verb, version)
			  end
			elsif verb.eql? 'CONNECT'
			  puts "HTTPS request"
			elsif verb.eql? 'POST'
			  puts "POST request"
			end
			puts "pooling conn"
		end
	end
  
  def self.num_conns
    @connections
  end
  
  def auto_clean_conns
  	puts "#{@threads.size} threads running in pool"
		@threads = @threads.select { |t| t.alive? ? true : (t.join; false) }
		while @threads.size >= max_threads
			sleep 1
			@threads = @threads.select { |t| t.alive? ? true : (t.join; false) }
		end
	end
end
