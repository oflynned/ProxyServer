class Block
  WEB_ROOT = './public'  

  def initialize()
    puts "Block module initialized"
  end
  
  def request_file(request)
    puts request
    parent_path = File.expand_path("..", Dir.pwd)
	  req_uri = request.split(" ")[1]
	  path = URI.unescape(URI(req_uri).path)
	  clean = []
	   
	  parts = path.split("/")
	  parts.each do |part|
	  next if part.empty? || part == '.'
		  part == ".." ? clean.pop : clean << part
	  end
	  File.join(WEB_ROOT, *clean)
  end
  
  def check_req(stripped_url)
    if Helpers.read_blacklist.include?(stripped_url)
      return true
    else return false
    end
  end
  
  def check_url(url)
    if Helpers.read_blacklist.include?(url)
      return true
    else return false
    end
  end
  
  def block_req(request, socket)
    is_start
    path = request_file(request)
	  path = File.join(path, 'index.html') if File.directory?(path)
	
	  if File.exist?(path) && !File.directory?(path)
		  File.open(path, "rb") do |file|
			  socket.print 	"HTTP/1.1 200 OK\r\n" +
										  "Content-Type: #{content_type(path)}\r\n" +
										  "Content-Length: #{file.size}\r\n" +
										  "Connection: close\r\n"
			  socket.print "\r\n"
			  IO.copy_stream(file, socket)
		  end
	  else
		  message = "File not found error 404\n"
		  socket.print 	"HTTP/1.1 404 Not Found\r\n" +
									  "Content-Type: text/plain\r\n" +
									  "Content-Length: #{message.size}\r\n" +
									  "Connection: close\r\n"
		  socket.print "\r\n"
		  socket.print message
	  end
	  socket.close
	  is_end
	end
	
	def is_start
	  @done = false
	end
	
	def is_end
	  @done = true
	end
end
