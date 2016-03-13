require 'socket'
require 'uri'
require 'open-uri'
require 'fileutils'

#own classes
require 'require_all'
require_all 'modules'

#host definitions
host = 'localhost'
port = 2345

Helpers.module_initialization

allow = Allow.new
block = Block.new
cache = Cache.new
pool = Pool.new
@server = TCPServer.new(host, port)
superuser = Superuser.new(block)

Helpers.initialisation_preamble

loop do
	pool.create_conn(@server.accept, allow, block, cache, superuser)
end
