require_relative '../lib/mangdown'
require 'logger'


module DB
  extend self


  def create_pages!(chapter_id)
    logger = Logger.new('migration_log.log')
    chapter = Chapter.find(chapter_id)
    m_chapter = Mangdown::MDHash.new({
      name: chapter.name, uri:chapter.uri
    }).to_chapter
    m_chapter.pages.each do |page|
      Page.create({
        name: page.name, uri: page.uri, chapter_id: chapter_id
      })
    end
  rescue Exception => error
    logger.error( error.message )
  end
end

