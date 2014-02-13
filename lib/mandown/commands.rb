module M
  extend self

  include ::Mandown
  extend ::Mandown::Tools

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
    
    fnd.collect! {|m| {uri: m[0], name: m[1]} }

    puts "Could not find manga" if fnd.empty?     
    
    fnd
  end
  
  def download(manga, bgn = 0, nd = -1)
    m = slow_get_chapters(manga, bgn - 1, nd - 1)
    slow_dl_chapters(m)
  end

  def cbz(dir)
    CBZ.all(dir)
  end

  class Array
    def get_manga
      puts 'works'
    end
  end
end
