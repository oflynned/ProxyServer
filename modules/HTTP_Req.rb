require 'net/http'
require "uri"

class HTTP_Req
  def initialize()
    puts "HTTP module initialized"
  end
  
  def get_req(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    
    puts response.code
    puts response.body
    puts response["cache-control"]
  end
  
  def relay(client_relay)
    request = client_relay.readline
  end
end
