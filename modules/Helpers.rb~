class Helpers

  DEFAULT_CONTENT_TYPE = 'application/octet-stream'
  CONTENT_TYPE_MAPPING = {
	  'html' => 'text/html',
	  'css' => 'text/css',
	  'txt' => 'text/plain',
	  'png' => 'image/png',
	  'jpeg' => 'image/jpeg'
  }
  
  def self.content_type(path)
	  ext = File.extname(path).split(".").last
	  CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
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
    
    if url.include?('/')
    	url["/"] = ""
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
  
  def self.strip_all_but_domain(input)
  	input.sub(/.*?([^.]+(\.com|\.co\.uk|\.uk|\.nl))$/, "\\1")
  	input
  end
  
  def self.read_blacklist
    website_list = ""
    File.open('public/blacklist/blacklist.txt', 'r') do |file|  
      while website = file.gets  
        website_list += website
      end
    end
    website_list
  end
  
  def self.write_blacklist(website)
    File.open('public/blacklist/blacklist.txt', 'w') do |file|
      file.puts website  
    end 
  end
end
