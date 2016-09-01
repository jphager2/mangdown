module Mangdown
  class MDHash
    include Equality
    include Properties

    properties :name, :uri, :manga, :chapter, :site

    def initialize(options = {})
      uri = options.fetch(:uri)
      site = options[:site]

      @name = options[:name]
      @manga = options[:manga]
      @chapter = options[:chapter]

      @adapter = Mangdown.adapter!(uri, site, nil, name)

      @uri = URI.escape(uri)
      @site = adapter.site
    end

    def to_manga_list
      type_error('manga_list') unless adapter.is_manga_list?

      list = MangaList.new
      list.load_manga(uri)
      list
    end

    def to_manga
      type_error('manga') unless adapter.is_manga?
      
      if name.to_s.empty?
        fill_properties(adapter.manga)
      end

      manga = Manga.new(uri, name)
      manga.adapter = adapter
      manga.load_chapters
      manga
    end

    def to_chapter
      type_error('chapter') unless adapter.is_chapter?

      if name.to_s.empty? || manga.to_s.empty? || chapter.to_s.empty?
        fill_properties(adapter.chapter)
      end

      number = chapter

      chapter = Chapter.new(uri, name, manga, number)
      chapter.adapter = adapter
      chapter.load_pages
      chapter
    end

    def to_page 
      type_error('page') unless adapter.is_page?

      Page.new(uri, name, manga, chapter)
    end 

    private

    def adapter
      @adapter
    end

    def type_error(type)
      raise NoMethodError, "This is not a known #{type} type"
    end
  end
end
