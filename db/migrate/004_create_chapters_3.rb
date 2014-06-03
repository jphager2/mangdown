require_relative '../../lib/mangdown'

class CreateChapters3 < ActiveRecord::Migration
  def up
    a_mangas = Manga.select do |m|
      m.name.downcase >= 'h' and m.name.downcase <= 'l' and m.site_id == 1
    end 

    a_mangas.each do |manga|
      m = Mangdown::Manga.new(manga.name, manga.uri)
      m.chapters_list.each do |md_hash| 
        Chapter.create(md_hash.to_h.merge({manga_id: manga.id}))
      end
    end
  end

  def down
  end
end
 
