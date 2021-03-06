require 'fileutils'

class Cache
  ##files needed
  #version.txt in root of site folder
  #subfolders containing requires files

  def initialize()
    puts "Cache module initialized"
    @directory = []
  end
  
  def check_version(uri, version)
    if File.exists?(path) && !File.directory?(path)
      File.open(uri, 'r') do |file|
        old_version = file.read
        if old_version.eql? version
          return "SAME VERSION"
        else return "DIFFERENT VERSION"
        end
      end
    else return "NOT FOUND"
    end
  end
  
  def prep_dir(uri)
    path = URI.unescape(URI(uri).path)
    parts = path.split("/")
    parts.each do |part|
      next if part.empty? || part == '.'
      @directory << part
    end
    @file_name = @directory.last
    @directory.pop
    return @directory
  end
      
  def cache(data, uri, website)
    @directory = []
    prep_dir(uri)
    puts Dir.pwd
    path = Dir.pwd + '/public/cached/' + website + '/'
    @directory.each do |dir|
      path += dir + '/'
      puts path
      Dir.mkdir(path)
    end
    save(path, @file_name, data, website)
  end
  
  def save(directory, file_name, data, website)
    cached_path = "public/cached/" + website + '/' + directory + file_name
    #cached_path = Dir.pwd + '/' + cached_path
    if File.exists?(cached_path)
      puts "Retrieving #{file_name} from cache (#{website})"
      return IO.read(cached_path)
    else
      puts cached_path
      puts "Caching #{file_name} from #{website}"
      File.open(cached_path, 'w') do |file|
        file.puts "test!"
      end
      puts "here?"
    end
  end
  
  def get(uri, socket)
    IO.copy_stream(file, socket)
  end
  
  def purge(uri)
  
  end
end
