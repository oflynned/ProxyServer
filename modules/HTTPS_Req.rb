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
		ssl_client = OpenSSL::SSL::SSLSocket.new(tcp_client)
		ssl_client.connect
		cert = OpenSSL::X509::Certificate.new(ssl_client.peer_cert)
	  
	  certprops = OpenSSL::X509::Name.new(cert.issuer).to_a
		issuer = certprops.select { |name, data, type| name == "O" }.first[1]
		results = { 
				        :valid_on => cert.not_before,
				        :valid_until => cert.not_after,
				        :issuer => issuer,
				        :valid => (ssl_client.verify_result == 0)
				      }
		
		puts results
		ssl_client.sysclose
		
		context = OpenSSL::SSL::SSLContext.new(:SSLv3)
		context.cert = OpenSSL::X509::Certificate.new(cert)
		ssl_client = OpenSSL::SSL::SSLSocket.new(tcp_client, context)
		ssl_client.connect
		
		puts ("\n\n#{verb} #{@uri.path}?#{@uri.query} HTTP/#{version}\r\n")
		ssl_client.puts("\n\n#{verb} #{@uri.path}?#{@uri.query} HTTP/#{version}\r\n")
		puts "1"
    ssl_client.flush
    puts ssl_client.gets	
		
		ssl_client.sysclose
		tcp_client.close
	  client_s.close
  end
end
