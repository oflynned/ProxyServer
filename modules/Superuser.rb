class Superuser
  #commands -> su --exit
  ##--exit -> force exit
  ##--help -> spawns help list of commands
  ##--block <http://www.example.com/> -> adds new file to block list
  ##--blacklist -> lists items on blacklist
  ##--check <http://www.example.com/> -> checks if site is blocked
  ##--connections -> lists the amount of current connections
  ##--restart -> kicks all peers and restarts the server
  ##--kick-all -> kicks all peers
  ##--dump-cache -> clears cache

  def initialize(block)
    puts "Superuser module initialized"
    @@block = block
    @thread = Thread.new{su}
  end
  
  def su
    puts_su "To pass commands to Superuser, prefix commands with 'su' for access. Type su --help for a list of commands." 
    cmd = gets.chomp
    
	  su_inv = cmd.split(" ")[0]
	  su_verb = cmd.split(" ")[1]
	  su_website = cmd.split(" ")[2]
	  
	  if su_inv.eql?('su')
	    if su_verb.eql?('--help')
	      help
	    elsif su_verb.eql?('--exit')
	      f_exit
	    elsif su_verb.eql?('--check')
	      if not su_website.nil?
	        check(su_website)
	      end
	    elsif su_verb.eql?('--block')
	      if not su_website.nil?
	        add_to_blacklist(su_website)
	      end
	    elsif su_verb.eql?('--blacklist')
	      blacklist
	    elsif su_verb.eql?('--connections')
	      connections
	    elsif su_verb.eql?('--restart')
	      restart
	    elsif su_verb.eql?('--kick-all')
	      kick_all
	    elsif su_verb.eql?('--dump-cache')
	      dump_cache
	    else puts "su: Incorrect command input, check via su --help"
	    end
	  else
	    puts "su: No call to su, ensure there is a su prefix"
	  end
	  su_inv = ""
	  su_verb = ""
	  su_website = ""
    @thread = Thread.new{su}
  end
  
  def f_exit
    puts "\nsu: force exit invoked!"
    abort
  end
  
  def help
    puts_su "Help invoked"
    print_commands
  end
  
  def print_commands
    puts "\n********************************************"
    puts "Commands"
    puts "Usage: su --<cmd>"
    puts "--blacklist -> lists items on blacklist"
    puts "--block <http://www.example.com/> -> adds new file to the blacklist"
    puts "--check <http://www.example.com/> -> checks if site is blacklisted"
    puts "--connections -> lists the amount of current connections"
    puts "--dump-cache -> clears cache"
    puts "--exit -> force exit"
    puts "--help -> spawns help list of commands"
    puts "--kick-all -> kicks all peers"
    puts "********************************************\n"
  end
  
  def add_to_blacklist(url)
    puts "\n"
    Helpers.write_blacklist(url)
    puts_su "#{url} has been added to the blacklist"
  end
  
  def blacklist
    puts "\n"
    puts_su "Items currently blacklisted:"
    Helpers.read_blacklist
  end
  
  def check(url)
    puts "\n"
    puts_su "Checking #{url}"
    if Helpers.read_blacklist.include?(url)
      puts_su "#{url} is a blacklisted website!"
    else
      puts_su "#{url} is not a blacklisted website and is allowed!"
    end      
  end
  
  def connections
    conns = Pool.num_conns
    puts_su "#{conns} active"
  end
  
  def puts_su(phrase)
    puts "! su: #{phrase}"
  end
  
end
