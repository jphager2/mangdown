# frozen_string_literal: true

require 'scrapework'

module Mangdown
  # Adapter for mangabat
  class MangaBat
    ROOT = 'https://mangabat.com/'
    CDNS = [
      %r{^https://s\d.mkklcdnv\d.com/mangakakalot}
    ].freeze

    def for?(uri)
      uri.to_s.start_with?(ROOT) || cdn_uri?(uri)
    end

    def cdn_uri?(uri)
      CDNS.any? { |cdn| uri.match?(cdn) }
    end

    def manga_list
      MangaList.load('https://mangabat.com/manga_list')
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

    # A manga list web page
    class MangaList < Scrapework::Object
      has_many :manga, class: 'Mangdown::MangaBat::Manga'

      def each(*args, &block)
        to_enum.each(*args, &block)
      end

      def to_enum
        Enumerator.new do |yielder|
          page = self

          while page
            page.manga.each { |manga| yielder << manga }

            page = page.next_page
          end
        end
      end

      map 'manga' do |html|
        html.css('.update_item h3 a').map do |a|
          uri = URI.join(ROOT, a[:href]).to_s

          { url: uri, name: a.text.strip }
        end
      end

      paginate do |html|
        pages = html.css('.group-page a').to_a[1..-2]
        current = pages.find_index { |p| p['class'] == 'pageselect' }

        prev_page_link = pages[current - 1] if current
        next_page_link = pages[current + 1] if current

        prev_page = { url: prev_page_link['href'] } if prev_page_link
        next_page = { url: next_page_link['href'] } if next_page_link

        [prev_page, next_page]
      end
    end

    # A manga web page
    class Manga < Scrapework::Object
      attribute :name

      has_many :chapters, class: 'Mangdown::MangaBat::Chapter'

      map :name do |html|
        html.css('h1.entry-title').text.strip
      end

      map :chapters do |html|
        html.css('.chapter-list .row a').reverse.map.with_index do |chapter, i|
          i += 1
          padded_number = i.to_s.rjust(3, '0')
          chapter_name = "#{name} #{padded_number}"

          { url: chapter['href'], name: chapter_name, number: i }
        end
      end
    end

    # A manga chapter web page
    class Chapter < Scrapework::Object
      attribute :name
      attribute :number, type: Integer

      belongs_to :manga, class: 'Mangdown::MangaBat::Manga'
      has_many :pages, class: 'Mangdown::MangaBat::Page'

      map :name do |html|
        html.at_css('h1.entity-title').text.strip
      end

      map :manga do |html|
        manga = html.at_css('.breadcrumbs_doc p span:nth-child(3) a')

        { url: manga['href'], name: manga.text.strip }
      end

      map :pages do |html|
        html.css('.vung_doc img').map.with_index do |page, i|
          i += 1
          url = page['src']
          padded_number = i.to_s.rjust(3, '0')
          padded_chapter = number.to_s.rjust(3, '0')
          name = "#{manga.name} #{padded_chapter}-#{padded_number}"

          { url: url, name: name, number: i }
        end
      end

      def hydra_opts
        { max_concurrency: 10 }
      end
    end

    # A manga page image
    class Page < Scrapework::Object
      attribute :name
      attribute :number, type: Integer

      belongs_to :chapter, class: 'Mangdown::MangaBat::Chapter'
    end
  end
end
