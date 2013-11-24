module M
  extend self

  include ::Mandown

  def find(manga_name)
    @@list ||= PopularManga.new('http://www.mangareader.net/popular', 3000)

    fnd = @@list.mangas_list.select do |m| 
      m[1].downcase.include?(manga_name.downcase)
    end
    
    fnd.collect! {|m| Manga.new(m[0], m[1])}

    puts "Could not find manga" if fnd.empty?     
    
    fnd
  end
  
  def download(manga, bgn, nd)
    
  end

  def cbz(manga)

  end
end
