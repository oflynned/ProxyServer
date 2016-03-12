require_relative 'Helpers'

class Block
  WEB_ROOT = './public'

  BLACK_LISTED_WEBSITES = [
    'http://www.glassbyte.com/',
    'http://www.syzible.com/'
  ]
  
  DEFAULT_CONTENT_TYPE = 'application/octet-stream'
  CONTENT_TYPE_MAPPING = {
	  'html' => 'text/html',
	  'css' => 'text/css',
	  'txt' => 'text/plain',
	  'png' => 'image/png',
	  'jpeg' => 'image/jpeg'
  }
  
  def initialize()
    puts "Block module initialized"
  end
  
  def content_type(path)
	  ext = File.extname(path).split(".").last
	  CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
  end
  
  def request_file(request)
    if !request.nil?
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
  end
  
  
  def check_url(url)
    if BLACK_LISTED_WEBSITES.include?(url)
      return true
    else return false
    end
  end
  
  def block_req(path, socket)
  puts "blacklisting request"
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
	#else not found - echo 404
		message = "File not found error 404\n"
		socket.print 	"HTTP/1.1 404 Not Found\r\n" +
										"Content-Type: text/plain\r\n" +
										"Content-Length: #{message.size}\r\n" +
										"Connection: close\r\n"
		socket.print "\r\n"
		socket.print message
	end
end
end