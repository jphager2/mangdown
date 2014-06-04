require_relative '../lib/mangdown'
require 'logger'

module DB
  extend self 

  def create_chapters!(start_char, end_char, site_id) 
    logger = Logger.new('migrate_log.log')

    a_mangas = Manga.select do |m|
      m.name.downcase >= start_char and 
        m.name.downcase <= end_char and 
        m.site_id == 2
    end 

    a_mangas.each do |manga|
      begin
        m = Mangdown::Manga.new(manga.name, manga.uri)
        m.chapters_list.each do |md_hash| 
          Chapter.create(md_hash.to_h.merge({manga_id: manga.id}))
        end
      rescue Exception => error
        logger.error(Time.now.to_s + ' ' + error.message)
        next
      end
    end
  end
end

 
