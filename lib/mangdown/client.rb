require_relative '../mangdown'

module M
  extend self

  DATA_FILE_PATH = Dir.home + '/.manga_list.yml'
  HELP_FILE_PATH = File.expand_path(
    '../../README.md', File.dirname(__FILE__)
  )
=begin
  MANGA_PAGES = (1..9).map { |p| 
      "http://www.wiemanga.com/search/?name_sel=contain" +
      "&author_sel=contain&completed_series=either&page=#{p}.html"
    } +
    [
      'http://www.mangareader.net/alphabetical',
      'http://mangafox.me/manga/'
    ]
=end
  MANGA_PAGES = ['http://www.mangareader.net/alphabetical']

  # return a list of hash with :uri and :name of mangas found in list
  def find(search)
    search = Regexp.new(/^#{search}$/) if search.respond_to?(:to_str)

    current_manga_list.mangas.select { |manga| manga[:name] =~ search }
  end

  # cbz all subdirectories in a directory
  def cbz(dir)
    Dir.exist?(dir) ? Mangdown::CBZ.all(dir) : raise(Errno::ENOENT, dir) 
  end

  # display help file
  def help
    puts File.read(HELP_FILE_PATH)
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
    return Mangdown::MangaList.from_data(data) if data

    Mangdown::MangaList.new(*MANGA_PAGES).tap { |list| 
      File.open(path, 'w+') { |f| f.write(list.to_yaml) } 
    }
  rescue Object => error
    puts "#{path} may be corrupt: #{error.message}"
    raise
  end
end
