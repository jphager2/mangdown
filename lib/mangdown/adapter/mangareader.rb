# frozen_string_literal: true

require 'scrapework'

module Mangdown
  # Adapter for mangareader
  class Mangareader
    ROOT = 'https://www.mangareader.net'

    def for?(uri)
      URI.parse(uri).host&.end_with?('mangareader.net')
    rescue URI::Error
      false
    end

    def manga_list
      MangaList.load('https://www.mangareader.net/alphabetical')
    end

    def manga(url)
      Manga.load(url)
    end

    def chapter(url)
      Chapter.load(url)
    end

    def page(url)
      Page.load(url)
    end

    # A mangareader manga list
    class MangaList < Scrapework::Object
      has_many :manga, class: 'Mangdown::Mangareader::Manga'

      map :manga do |html|
        html.css('ul.series_alpha li a').map do |a|
          uri = "#{ROOT}#{a[:href]}"

          { url: uri, name: a.text.strip }
        end
      end

      def each(&block)
        manga.each(&block)
      end

      def to_enum
        manga.to_enum
      end
    end

    # A mangareader manga
    class Manga < Scrapework::Object
      attribute :name

      has_many :chapters, class: 'Mangdown::Mangareader::Chapter'

      map :name do |html|
        html.at_css('h2.aname').text.strip
      end

      map :chapters do |html|
        html.css('div#chapterlist td a').map.with_index do |a, i|
          uri = ROOT + a[:href]

          { url: uri, name: a.text.strip, number: i + 1 }
        end
      end
    end

    # A mangareader chapter
    class Chapter < Scrapework::Object
      attribute :name
      attribute :number, type: Integer

      belongs_to :manga, class: 'Mangdown::Mangareader::Manga'
      has_many :page_views, class: 'Mangdown::Mangareader::PageView'

      map :name do |html|
        name = html.at_css('#mangainfo h1').text.strip
        name.sub(/(\d+)$/) { Regexp.last_match[1].rjust(5, '0') }
      end

      map :number do |html|
        _mapped_name.slice(/(\d+)$/, 1)
      end

      map :manga do |html|
        manga = html.at_css('#mangainfo h2.c2 a')

        {
          url: "#{ROOT}#{manga['href']}",
          name: manga.text.strip.sub(/ Manga$/, '')
        }
      end

      map :page_views do |html|
        html.css('#selectpage select#pageMenu option').map.with_index do |op, i|
          i += 1
          uri = "#{ROOT}#{op['value']}"
          padded_number = i.to_s.rjust(3, '0')
          padded_chapter = number.to_s.rjust(5, '0')
          name = "#{manga.name} #{padded_chapter}-#{padded_number}"

          { url: uri, name: name, number: i }
        end
      end

      def hydra_opts
        {}
      end

      def pages
        return @pages if defined?(@pages)

        threads = []
        page_views.each do |page_view|
          threads << Thread.new(page_view, &:page)
        end
        threads.each(&:join)

        @pages = page_views.map(&:page)
      end
    end

    # A mangareader page
    class PageView < Scrapework::Object
      attribute :name
      attribute :number, type: Integer

      belongs_to :chapter, class: 'Mangdown::Mangareader::Chapter'
      has_one :page, class: 'Mangdown::Mangareader::Page'

      alias uri url

      map :chapter do |html|
        name = html.at_css('.mangainfo h1').text.strip
        op = html.css('#selectpage select#pageMenu option').first

        { url: "#{ROOT}#{op['href']}", name: name }
      end

      map :page do |html|
        img = html.at_css('#imgholder img#img')

        { url: img['src'], name: name, number: number }
      end
    end

    # A mangareader page
    class Page < Scrapework::Object
      attribute :name
      attribute :number, type: Integer

      belongs_to :page_view, class: 'Mangdown::Mangareader::PageView'

      def chapter
        page_view.chapter
      end
    end
  end
end
