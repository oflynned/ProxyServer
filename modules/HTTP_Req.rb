require "uri"

BUFF_SIZE = 4048

class HTTP_Req
  def initialize()
    puts "HTTP module initialized"
  end
  
  def retrieve_page(client_s, uri, verb, version)
  	server_s = TCPSocket.new(uri.host, (uri.port.nil? ? HTTP_PORT : uri.port))
		#puts "#{verb} #{uri.path}?#{uri.query} HTTP/#{version}\r\n"
		server_s.write("\n\n#{verb} #{uri.path}?#{uri.query} HTTP/#{version}\r\n")
  
		content_len = 0
    loop do     
      line = client_s.readline
      
      if line =~ /^Content-Length:\s+(\d+)\s*$/
        content_len = $1.to_i
      end
      
      # Strip proxy headers
      if line =~ /^proxy/i
        next
      elsif line.strip.empty?
        server_s.write("Connection: close\r\n\r\n")
        if content_len >= 0
          server_s.write(client_s.read(content_len))
        end
        break
      else
        server_s.write(line)
      end
    end
    
    buff = ""
    loop do
      server_s.read(BUFF_SIZE, buff)
      client_s.write(buff)
      break if buff.size < BUFF_SIZE
    end
    
    client_s.close
    server_s.close
  end
end
