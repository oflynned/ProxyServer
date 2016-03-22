require 'openssl'
require 'socket'
require 'uri'
require 'net/http'

class HTTPS_Req

PROXY_HOST = "localhost"
PROXY_PORT = 2016

  def initialize()
    puts "HTTPS module initialized"
  end
  
  def retrieve_page(client_s, url, verb, version)
		puts "SSL page retrieved!"
		
		url = 'https://' + url
		url.sub!(":443", "")
		puts url
		
		@uri = URI(url)
		
		puts "URI: #{@uri}"
		puts "Host: #{@uri.host}"
		puts "Port: #{@uri.port}"
		puts "Scheme: #{@uri.scheme}"
		
		#Net::HTTP.start(@uri.host, @uri.port,   
    #  :use_ssl => @uri.scheme == 'https') do |http|
    #  request = Net::HTTP::Get.new @uri
    #  response = http.request request
    #  puts response.body
    #  client_s.write(response.body)
    #end
		
		tcp_client = TCPSocket.new(@uri.host, @uri.port)
    puts "1"
		context = OpenSSL::SSL::SSLContext.new
    puts "1"
    context.cert = OpenSSL::X509::Certificate.new("public/certs/cacert.pem")
    
    puts "1"
    ssl_client = OpenSSL::SSL::SSLSocket.new(tcp_client, context)
    puts "1"
    ssl_client.connect
    puts "2"
    response = ssl_client.gets
    client_s.write(response.body)
		
		ssl_client.sysclose
    tcp_client.close
	  client_s.close
  end
end
