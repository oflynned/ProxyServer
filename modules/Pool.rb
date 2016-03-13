class Pool
  def initialize()
    puts "Pooling module initialized"
    @connections = 0
  end
  
  def pool_conn(block, allow, is_blocked, request, socket)
    puts "Creating new connection in pool"
    @connections = @connections + 1
    puts @connections
    if is_blocked
      puts "blocked via thread instantiation"
      puts is_blocked
      conn = Thread.new {block.block_req(request, socket)}
      if block.is_end
        conn.join
      end
    else
      puts "allowed via thread instantiation"
      conn = Thread.new {allow.retrieve_page(socket, Helpers.get_url(request))}
      if allow.is_end
        conn.join
      end
    end
  end
  
  def kill_thread(thread)
    puts "Killing connection thread in pool"
    thread.kill
  end
end
