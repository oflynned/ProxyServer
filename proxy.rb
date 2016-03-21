require 'socket'
require 'uri'
require 'open-uri'
require "openssl"

#own classes
require 'require_all'
require_all 'modules'

#host definitions
HOST = 'localhost'
SERVER_PORT = 2016

@server = TCPServer.new(HOST, SERVER_PORT)
pool = Pool.new

loop do
	pool.pool_conn(@server)
	#pool.auto_clean_conns
end
