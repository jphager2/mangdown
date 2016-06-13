module Mangdown
  class MDHash
    include Equality
    include Properties

    properties :name, :uri, :manga, :chapter, :site

    def initialize(options = {})
      uri = options.fetch(:uri)
      name = options[:name]
      site = options[:site]
      @adapter = Mangdown.adapter!(uri, site, nil, name)

      self.name = name
      self.uri = Mangdown::Uri.new(uri)
      self.site = @adapter.site
      self.manga = options[:manga]
      self.chapter = options[:chapter]
    end

    # explicit conversion to manga list
    def to_manga_list
      # Seems weird to do it this way, but this is to intentially make it 
      # more tedious to create a Mangadown::Manga object 
      # (outsite of this method)
      #
      if @adapter.is_manga_list?
        list = MangaList.new
        list.load_manga(uri)
        list
      else
        raise NoMethodError, 'This is not a known manga list type'
      end
    end

    # explicit conversion to manga 
    def to_manga
      # Seems weird to do it this way, but this is to intentially make it 
      # more tedious to create a Mangadown::Manga object 
      # (outsite of this method)
      #
      if @adapter.is_manga?
        if name.to_s.empty?
          properties.merge!(@adapter.manga) { |_, before, after| 
            before || after }
        end

        manga = Manga.new(uri, name)
        manga.adapter = @adapter
        manga.load_chapters
        manga
      else
        raise NoMethodError, 'This is not a known manga type'
      end
    end

    # explicit conversion to chapter 
    def to_chapter
      # Seems weird to do it this way, but this is to intentially make it 
      # more tedious to create a Mangadown::Chapter object 
      # (outsite of this method)
      #
      if @adapter.is_chapter?
        if name.to_s.empty? || manga.to_s.empty? || chapter.to_s.empty?
          properties.merge!(@adapter.chapter) { |_, before, after| 
            before || after }
        end
        # Get a local binding
        number = chapter

        chapter = Chapter.new(uri, name, manga, number)
        chapter.adapter = @adapter
        chapter.load_pages
        chapter
      else
        raise NoMethodError, 'This is not a known chapter type'
      end
    end

    # explicit conversion to page 
    def to_page 
      if @adapter.is_page?
        Page.new(uri, name, manga, chapter)
      else
        raise NoMethodError, 'This is not a known page type'
      end
    end 
  end
end
