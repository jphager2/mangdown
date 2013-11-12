require_relative '../lib/mandown'

include Mandown

p = PopularManga.new('http://www.mangareader.net/popular', 10, "Top 10")

index = p.mangas_list.find_index {|m| m[1].downcase.include?('naruto')}

p.get_manga(index + 1) if index

naruto = p.mangas.first

range = (-2..0)

range.each {|i| naruto.get_chapter(i)}

naruto.chapters.each {|c| c.download}
