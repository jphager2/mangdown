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
    @@list ||= PopularManga.new(
                 'http://www.mangareader.net/popular', 3000)

    search_result = @@list.mangas_list.select do |manga| 
      manga[1].downcase.include?(search.downcase)
    end
    
    search_result.collect! do |manga| 
      h = MDHash.new
      h[:uri], h[:name] = manga[0], manga[1]
      h
    end

    puts "Could not find manga" if search_result.empty?     
    
    search_result
  end
  
  def download(manga, first_chapter = 0, last_chapter = -1)
    chapters = slow_get_chapters(manga, first_chapter, last_chapter)
    slow_dl_chapters(chapters)
  end

  def cbz(dir)
    CBZ.all(dir)
  end

  def help
    help_file = File.expand_path('../../doc/help.txt', 
                                 File.dirname(__FILE__))
    puts File.open(help_file, 'r').read
  end
end
