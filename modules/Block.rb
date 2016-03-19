class Block
  WEB_ROOT = 'public'  
  INDEX = "index.html"

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
	  #File.join(WEB_ROOT, *clean)
	  File.join(Dir.pwd, WEB_ROOT)
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
    path = request_file(request)
	  path = File.join(path, INDEX) if File.directory?(path)
	  
	  puts path
	
		message = 
			"<head>
				<title>Blocked!</title>
				<meta charset=\"utf-8\">
			</head>

			<body>
				<h2>This website has been blacklisted from use.</h2>
				<p>Please contact your system administrator.</p>
			</body>"
		  
	 	socket.print 	"HTTP/1.1 200 OK\r\n" +
							  	"Content-Type: text/html\r\n" +
							  	"Content-Length: #{message.size}\r\n" +
							  	"Connection: close\r\n"
		socket.print "\r\n"
		socket.print message
	  socket.close
	end
end
