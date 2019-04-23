class TestAdapter
  def for?(url)
    true
  end

  def manga_list
    MangaList.new
  end

  def manga(url)
    @manga_called ||= 0
    @manga_called += 1

    @manga_stub ||= Manga.load(url)
  end
  attr_reader :manga_called, :manga_stub

  def chapter(url)
    @chapter_called ||= 0
    @chapter_called += 1

    @chapter_stub ||= Chapter.load(url)
  end
  attr_reader :chapter_called, :chapter_stub

  def page(url)
    @page_called ||= 0
    @page_called += 1

    @page_stub ||= Page.load(url)
  end
  attr_reader :page_called, :page_stub

  class Manga < Scrapework::Object
    attr_accessor :name

    def chapters
      @chapters_called ||= 0
      @chapters_called += 1

      @chapters_stub ||= []
    end
    attr_reader :chapters_called, :chapters_stub
  end
  class Chapter < Scrapework::Object
    attr_accessor :name
    attr_accessor :manga
    attr_accessor :number

    def pages
      @pages_called ||= 0
      @pages_called += 1

      @pages_stub ||= []
    end
    attr_reader :pages_called, :pages_stub
  end
  class Page < Scrapework::Object
    attr_accessor :name
  end
end
