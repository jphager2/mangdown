module M
  extend self

  include ::Mangdown
  extend ::Mangdown::Tools

  #returns a list of hash with :uri and :name of mangas found in @@list
  def find(manga_name)
    unless manga_name =~ /\w/
      puts 'Bad search term'
      return []
    end

    @@list ||= PopularManga.new('http://www.mangareader.net/popular', 3000)

    fnd = @@list.mangas_list.select do |m| 
      m[1].downcase.include?(manga_name.downcase)
    end
    
    fnd.collect! do |m| 
      h = MDHash.new
      h[:uri], h[:name] = m[0], m[1]
      h
    end

    puts "Could not find manga" if fnd.empty?     
    
    fnd
  end
  
  def download(manga, bgn = 0, nd = -1)
    m = slow_get_chapters(manga, bgn, nd)
    slow_dl_chapters(m)
  end

  def cbz(dir)
    CBZ.all(dir)
  end

  def help
    help_file = File.expand_path('../../doc/help.txt', File.dirname(__FILE__))
    puts help_file
    puts File.open(help_file, 'r').read
  end
end
