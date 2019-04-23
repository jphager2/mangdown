# frozen_string_literal: true

# rubocop:disable Naming/MemoizedInstanceVariableName
class TestAdapter
  def for?(_url)
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
    attribute :name

    def chapters
      @chapters_called ||= 0
      @chapters_called += 1

      @chapters_stub ||= []
    end
    attr_reader :chapters_called, :chapters_stub

    map(:name) {}

    def html
      ''
    end
  end
  class Chapter < Scrapework::Object
    attribute :name
    attribute :number

    attr_accessor :manga

    def pages
      @pages_called ||= 0
      @pages_called += 1

      @pages_stub ||= []
    end
    attr_reader :pages_called, :pages_stub

    map(:name) {}
    map(:number) {}

    def html
      ''
    end
  end
  class Page < Scrapework::Object
    attribute :name

    map(:name) {}

    def html
      ''
    end
  end
end
# rubocop:enable Naming/MemoizedInstanceVariableName
