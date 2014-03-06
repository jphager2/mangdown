module M
  extend self

  include ::Mangdown
  extend ::Mangdown::Tools

  def valid_search?(search)
    search =~ /\w/
  end
  
  #returns a list of hash with :uri and :name of mangas found in @@list
  def find(search)
    unless valid_search?(search)
      puts "Searches must contain letters and numbers.."
      return []
    end
    
    # change this: Check for yml file with popular list
    # if it exists, then check if it was created this week
    # if it wasn't get a new list
    # if the yaml file doesn't exist get a new list
    # write the new list to the yaml file
    #
    # Previously, popular manga was used for find, but there is a 
    # much better way to do it
    # PopularManga.new('http://www.mangareader.net/popular', 3000)

    file_path = Dir.home + '/.manga_list.yml'
    file_current = File.mtime(file_path) > (Time.now - 60*60*24*7)

    if File.exist?(file_path) and file_current
      @@list = YAML.load(File.open(file_path, 'r').read)
    else
      @@list = MangaList.new('http://www.mangareader.net/alphabetical') 
      File.open(file_path, 'w+') do |f|
        f.write( @@list.to_yaml )
      end
    end

    search_result = @@list.mangas_list.select do |manga| 
      manga[:name].downcase.include?(search.downcase)
    end
    
    puts "Could not find manga" if search_result.empty?     
    
    search_result
  end
  
  def download(manga, first_chapter = 0, last_chapter = -1)
    chapters = ::Mangdown::Tools.slow_get_chapters(
       manga, first_chapter, last_chapter)
    ::Mangdown::Tools.slow_dl_chapters(chapters)
  end

  def cbz(dir)
    CBZ.all(dir)
  end

  def help
    help_file = File.expand_path('../../doc/help.txt', 
                                 File.dirname(__FILE__))
    puts File.open(help_file, 'r').read
  end

  def clean_up
    file_path = Dir.home + '/.manga_list.yml'
    File.delete(file_path) if File.exist?(file_path)
  end
end
