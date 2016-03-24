require 'socket'
require 'uri'
require "openssl"

#own classes
require 'require_all'
require_all 'modules'

#host definitions
HOST = 'localhost'
HTTP_PORT = 2016

@server = TCPServer.new(HOST, HTTP_PORT)

pool = Pool.new

loop do
	pool.pool_conn(@server, @server)
	#pool.auto_clean_conns
end
