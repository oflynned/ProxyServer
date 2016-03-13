require 'socket'

class Allow
  def initialize()
    puts "Allow module initialized"
  end
  
  def retrieve_page(socket, url)
    is_start
    puts "Retrieving content from " + url
    HTTP_Req.new.get_req(url)
    is_end
  end 
	
	def is_start
	  @done = false
	end
	
	def is_end
	  @done = true
	end
end
