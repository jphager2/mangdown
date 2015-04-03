module M
  extend self

  include ::Mangdown

  DATA_FILE_PATH = Dir.home + '/.manga_list.yml'
  HELP_FILE_PATH = File.expand_path(
    '../../doc/help.txt', File.dirname(__FILE__)
  )

  # return a list of hash with :uri and :name of mangas found in list
  def find(search)
    validate_search(search)
    current_manga_list.mangas.select { |manga| 
      manga[:name].downcase.include?(search.downcase) 
    }
  end

	# cbz all subdirectories in a directory
  def cbz(dir)
		Dir.exist?(dir) ? (CBZ.all(dir)) : (raise Errno::ENOENT, dir) 
  end

	# display help file
  def help
    puts File.open(HELP_FILE_PATH, 'r').read
  end

	# delete data file
  def clean_up
    File.delete(DATA_FILE_PATH) if File.exist?(DATA_FILE_PATH)
  end

  private
  # convenience method to access the data file path
  def path
    DATA_FILE_PATH
  end

  # check if the data file is current
  def file_current?(f)
    File.exists?(f) && File.mtime(f) > (Time.now - 604800)
  end

  # attempt to get the list from the data file
  def data_from_file
    YAML.load(File.read(path)) if file_current?(path)
  end

  # get saved current manga list, if data is less than a week old
  # otherwise fetch new data and write it to the data file
  def current_manga_list
    data = data_from_file
    return MangaList.from_data(data) if data.is_a? Array 

    MangaList.new(
      'http://www.mangareader.net/alphabetical',
      'http://mangafox.me/manga/'
    ).tap { |list| File.open(path,'w+') {|f| f.write(list.to_yaml)} }
  rescue Object => error
    puts "#{path} is corrupt: #{error.message}"
    raise
  end

  # check if the search key contains letters or numbers
  def validate_search(search)
    unless search =~ /\w/
      raise ArgumentError, "Searches must contain letters and numbers"
    end
  end
end
