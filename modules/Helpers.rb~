class Helpers

  def self.module_initialization()
    puts "\n"
    puts "**************************"
    puts "\n"
  end

  def self.initialisation_preamble()
    puts "\n"
    puts "**************************"
    puts "\nProxy server initialised on 127.0.0.1:2345"
    puts "\n"
  end

  def self.get_req(url, type)
    if not type.include? ('https')
      if type.include? ('http')
        req = 'GET ' + url + '/ HTTP/1.1'
        return req
      end
    else 
      puts "HTTPS requested"
    end
  end
  
  def self.get_url(request)
    puts request
    req_uri_full = request.split(" ")[1]
    req_uri_full
  end
  
  def self.splice_url(url)
  #remove prefixes for folder name in cache
    if not url.include?("https://")
      if url.include?("http://")
        url["http://"] = ""
      end
    else
      url["https://"] = ""
    end
    
    if url.include?('www.')
      url["www."] = ""
    end
    url
  end
  
  def self.retrieve_type(url)
    delimiter = ':'
    type = url.split(delimiter)[0]
    type
  end
  
  def self.retrieve_stripped(semi_stripped)
    delimiter = "."
    stripped = semi_stripped.split(delimiter)[0]
    stripped
  end
  
  def self.verb(input)
    verb = input[/^\w+/]
    verb
  end
  
  def self.url(input)
    url = input[/^\w+\s+(\S+)/, 1]
    url
  end
  
  def self.version(input)
    version = input[/HTTP\/(1\.\d)\s*$/, 1]
    version
  end 
  
  def self.uri(input)
    uri = URI::parse(input)
    uri
  end
end
