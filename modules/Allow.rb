require 'socket'

class Allow
  def initialize()
    puts "Allow module initialized"
  end
  
  def retrieve_page(socket, url)
    puts "Retrieving content from " + url
    http_req = HTTP_Req.new
    site_data = http_req.get_req(url)
    socket.write(site_data)
  end 
	
	def is_start
	  @done = false
	end
	
	def is_end
	  @done = true
	end
end
