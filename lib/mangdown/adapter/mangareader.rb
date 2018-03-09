# frozen_string_literal: true

require 'cgi'

module Mangdown
  # Mangdown adapter for mangareader
  class Mangareader < Adapter::Base
    site :mangareader

    attr_reader :root

    def initialize(uri, doc, name)
      super

      @root = 'https://www.mangareader.net'
    end

    def is_manga_list?(uri = @uri)
      uri == "#{root}/alphabetical"
    end

    def is_manga?(uri = @uri)
      uri.slice(/#{root}(\/\d+)?(\/[^\/]+)(\.html)?/i) == uri
    end

    def is_chapter?(uri = @uri)
      uri.slice(/#{root}(\/[^\/]+){1,2}\/(\d+|chapter-\d+\.html)/i) == uri
    end

    def is_page?(uri = @uri)
      uri.slice(/.+\.(png|jpg|jpeg)$/i) == uri
    end

    # Only valid mangas should be returned (using is_manga?(uri))
    def manga_list
      doc.css('ul.series_alpha li a').map do |a|
        uri = "#{root}#{a[:href]}"
        manga = { uri: uri, name: a.text.strip, site: site }

        manga if is_manga?(uri)
      end.compact
    end

    def manga
      { uri: uri, name: manga_name, site: site }
    end

    # Only valid chapters should be returned (using is_chapter?(uri))
    def chapter_list
      doc.css('div#chapterlist td a').map do |a|
        uri = root + a[:href].sub(root, '')
        chapter = { uri: uri, name: a.text.strip, site: site }

        chapter if is_chapter?(uri)
      end.compact
    end

    def chapter
      { uri: uri,
        manga: manga_name,
        name: chapter_name,
        chapter: chapter_number,
        site: site }
    end

    def page_list
      last_page = doc.css('select')[1].css('option').length
      (1..last_page).map do |page|
        slug = manga_name.tr(' ', '-').gsub(/[:,!]/, '')
        uri = "#{root}/#{slug}/#{chapter_number}/#{page}"
        uri = Addressable::URI.escape(uri).downcase
        { uri: uri, name: page, site: site }
      end
    end

    def page
      page_image = doc.css('img')[0]
      uri = page_image[:src]
      name = page_image[:alt].sub(/([^\d]*)(\d+)(\.\w+)?$/) do
        Regexp.last_match[1].to_s + Regexp.last_match[2].to_s.rjust(3, '0')
      end

      { uri: uri, name: name, site: site }
    end

    private

    def manga_name
      if is_manga?
        name = doc.css('h2.aname').text
      elsif is_chapter?
        name = chapter_manga_name
      end

      CGI.unescapeHTML(name) if name
    end

    def chapter_name
      if @name
        @name.sub(/\s(\d+)$/) { |num| ' ' + num.to_i.to_s.rjust(5, '0') }
      else
        doc.css('').text # Not implimented
      end
    end

    def chapter_manga_name
      if @name
        @name.slice(/(^.+)\s/, 1)
      else
        doc.css('').text # Not implimented
      end
    end

    def chapter_number
      if @name
        @name.slice(/\d+\z/).to_i
      else
        doc.css('').text # Not implimented
      end
    end
  end
end
