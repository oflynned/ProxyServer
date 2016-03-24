require 'openssl'
require 'socket'
require 'uri'
require 'net/http'
require 'httpclient'

SSL_BLOCK_SIZE = 16384
BUFF_SIZE = 4048
PROXY_HOST = "localhost"
PROXY_PORT = 2016

class HTTPS_Req

  def initialize()
    puts "HTTPS module initialized"
  end
  
  def retrieve_page(client_s, url, verb, version, request)
		puts "SSL page retrieved!"
		
		url = 'https://' + url
		url.sub!(":443", "")
		puts url
		
		@uri = URI(url)
		
		puts "URI: #{@uri}"
		puts "Host: #{@uri.host}"
		puts "Port: #{@uri.port}"
		puts "Scheme: #{@uri.scheme}"
		puts request
		
		tcp_socket = TCPSocket.new(@uri.host, @uri.port)
		ssl_context = OpenSSL::SSL::SSLContext.new
    ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    cert_store = OpenSSL::X509::Store.new
    cert_store.set_default_paths
    ssl_context.cert_store = cert_store
    
    no_ssl_2 = OpenSSL::SSL::OP_NO_SSLv2
    no_ssl_3 = OpenSSL::SSL::OP_NO_SSLv3
    no_ssl_compression = OpenSSL::SSL::OP_NO_COMPRESSION
    
    ssl_options = no_ssl_2 + no_ssl_3 + no_ssl_compression
    ssl_context.options = ssl_options
		ssl_socket = OpenSSL::SSL::SSLSocket.new(tcp_socket, ssl_context)
		ssl_socket.sync_close = true
		ssl_socket.connect
		
		while true
		  (ready_sockets, dummy, dummy) = IO.select([client_s, ssl_socket])
      begin
        ready_sockets.each do |socket|
          data = socket.readpartial(SSL_BLOCK_SIZE)
          puts data
          if socket == client_s
            # Read from client, write to server.
            ssl_socket.write(data)
            ssl_socket.flush
          else
            # Read from server, write to client.
            client_s.write data
            client_s.flush
          end
        end
      end
    end
    
    client_s.close
    ssl_socket.close
  end
end
