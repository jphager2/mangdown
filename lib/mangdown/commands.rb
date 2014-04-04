module M
  extend self

  include ::Mangdown

  DATA_FILE_PATH = Dir.home + '/.manga_list.yml'

	# check if the search key contains letters or numbers
  def valid_search?(search)
    search =~ /\w/
  end

	# check if the data file is current
	def file_current?(file)
		File.exists?(file) ? File.mtime(file) > (Time.now - 604800) : false
	end

  # return a list of hash with :uri and :name of mangas found in list
  def find(search)
    unless valid_search?(search)
      puts "Searches must contain letters and numbers.."
      return []
    end
    
		if file_current?(DATA_FILE_PATH)
      list = YAML.load(File.open(DATA_FILE_PATH, 'r').read)
    else
      list = MangaList.new(
        'http://www.mangareader.net/alphabetical',
        'http://mangafox.me/manga/'                       
      ) 

      File.open(DATA_FILE_PATH, 'w+') do |file|
        file.write( list.to_yaml )
      end
    end

    search_result = list.mangas.select do |manga| 
      manga[:name].downcase.include?(search.downcase)
    end
    
		search_result.empty? ? (puts "Could not find manga") : search_result
  end
  
	# download a manga (accepts MDHash) between the chapters given
	# by default the entire manga will be downloaded
  def download(manga, first = 0, last = -1)
    if manga.class == MDHash
			manga = manga.get_manga
    end

    chapters = Tools.slow_get_chapters(manga, first, last)
    Tools.slow_dl_chapters(chapters)
  end

	# cbz all subdirectories in a directory
  def cbz(dir)
		Dir.exist?(dir) ? CBZ.all(dir) : (puts "Cannot find directory")
  end

	# display help file
  def help
    help_file = File.expand_path('../../doc/help.txt', 
                                 File.dirname(__FILE__))
    puts File.open(help_file, 'r').read
  end

	# delete data file
  def clean_up
    File.delete(DATA_FILE_PATH) if File.exist?(DATA_FILE_PATH)
  end
end
