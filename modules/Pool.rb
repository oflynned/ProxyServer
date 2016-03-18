require 'socket'

class Pool
  def initialize()
    puts "Pooling module initialized"
    @connections = 0
  end
  
  def create_conn(socket, allow, block, cache, superuser)
	  request = socket.gets

    #file details	  
	  url = Helpers.url(request)
	  type = Helpers.retrieve_type(url)
	  verb = Helpers.verb(request)
	  version = Helpers.version(request)
	  folder_name = Helpers.splice_url(Helpers.get_url(request))
	  raw_name = Helpers.retrieve_stripped(folder_name)
	
	  if !request.nil?
	    if verb.eql? 'GET'
	      puts 'get req'
	    #elsif verb.eql 'POST'
	    #  puts 'post req'
	    #elsif verb.eql 'CONNECT'
	    #  puts 'connect req'
	    end
	    
	    is_blocked = block.check_url(url) or block.check_req(raw_name)
	    
	    if type.eql? 'http'
	      puts "HTTP request filtered" 
	      if is_blocked
	        puts "\nRequest to " + url + " has been blacklisted!\n"
	      else
	        puts "\nRequest to " + url + " has been whitelisted!\n"
	      end
	      pool_conn(block, allow, is_blocked, request, socket)
	    elsif type.eql? 'https'
	      puts "HTTPS request"
	    else
	      puts "SSL connect request?"
	    end
	  end
  end
  
  def pool_conn(block, allow, is_blocked, request, socket)
    puts "Creating new connection in pool"
    @connections += 1
    puts @connections
    if is_blocked
      puts "blocked via thread pool"
      puts is_blocked
      Thread.start() do |socket|
        s.write(block.block_req(request, socket))
        s.close
      end
    else
      puts "allowed via thread pool"
      Thread.start() do |socket|
        page_data = allow.retrieve_page(socket, Helpers.get_url(request))
        s.write(page_data)
        s.close
      end
    end
  end
  
  def self.num_conns
    @connections
  end
  
  def kill_thread(socket, thread)
    puts "Killing socket connection thread in pool"
    socket.close
    thread.kill
  end
end
