require 'socket'

class Allow
  def initialize()
    puts "Allow module initialized"
  end
  
  def retrieve_page(request, socket)
    puts "Retrieving content from " + Helpers.get_url(request)
  end 
  
  ##@deprecated
  def get_page(request, socket)
    url = get_url(request)
    puts url + " has been whitelisted"
    source = open(get_url(request)).read
    #puts source
    
    #check if dir exists
    #if not then create a directory
    spliced_url = splice_url(url)
    puts spliced_url
     
    curr_dir = Dir.pwd
    puts curr_dir
    
    #if not curr_dir.include?(spliced_url)
    #  Dir.chdir("public/cached")
    #  Dir.mkdir(spliced_url) unless File.exists?(spliced_url)
    #  Dir.chdir(spliced_url)
    #  puts Dir.pwd
    #else curr_dir.include?(spliced_url)
    #  puts Dir.pwd
    #  Dir.pwd.trim(spliced_url)
    #end
    
    open("index.html", "w") { |file|
      file.puts source
    }
    
    #return indexed cache to original window
    #hmmm...
  end
end
