module Mangdown
  class Mangareader < Adapter::Base


    def initialize(uri, doc, name)
      super
      @root                  ||= 'http://www.mangareader.net'
      @manga_list_css        = 'ul.series_alpha li a'
      @manga_name_css        = 'h2.aname'
      @chapter_list_css      = 'div#chapterlist td a'
      @manga_list_uri        = "#{@root}/alphabetical"
      @manga_link_prefix     = @root 
      @reverse_chapters      = false
      @manga_uri_regex       = 
        /#{@root}(\/\d+)?(\/[^\/]+)(\.html)?/i
      @chapter_uri_regex     = 
        /#{@root}(\/[^\/]+){1,2}\/(\d+|chapter-\d+\.html)/i
      @page_uri_regex        = /.+\.(png|jpg|jpeg)$/i
    end

    def is_manga_list?(uri = @uri)
      uri == "http://www.mangareader.net/alphabetical"
    end

    def is_manga?(uri = @uri)
      uri.slice(@manga_uri_regex) == uri
    end

    def is_chapter?(uri = @uri)
      uri.slice(@chapter_uri_regex) == uri
    end

    def is_page?(uri = @uri)
      uri.slice(@page_uri_regex) == uri
    end

    def manga_name
      if is_manga?
        name = doc.css(@manga_name_css).text
      elsif is_chapter?
        name = chapter_manga_name
      end

      CGI.unescapeHTML(name)
    end

    def chapter_name
      if @name
        @name.sub(/\s(\d+)$/) { |num| ' ' + num.to_i.to_s.rjust(5, '0') }
      else
        doc.css(@chapter_name_css).text
      end
    end

    def chapter_manga_name
      if @name
        @name.slice(/(^.+)\s/, 1) 
      else
        doc.css(@chapter_manga_name_css).text
      end
    end

    def chapter_number
      raise NoMethodError, "Not a chapter" unless is_chapter?

      if @name
        @name.slice(/\d+\z/).to_i 
      else
        doc.css(@chapter_number_css).text
      end
    end

    def build_page_uri(manga, chapter, page_num)
      slug = slug(manga)
      "#{root}/#{slug}/#{chapter}/#{page_num}"
    end

    def num_pages
      doc.css('select')[1].css('option').length
    end

    def page_image_src
      page_image[:src]
    end

    def page_image_name
      page_image[:alt].sub(/([^\d]*)(\d+)(\.\w+)?$/) { 
        "#{Regexp.last_match[1]}" +
        "#{Regexp.last_match[2].to_s.rjust(3, '0')}"
      }
    end

    # Only valid mangas should be returned (using is_manga?(uri))
    def manga_list
      doc.css(@manga_list_css).map { |a| 
        uri = "#{@manga_link_prefix}#{a[:href]}"
        manga = { uri: uri, name: a.text.strip, site: site }

        manga if is_manga?(manga[:uri])
      }.compact
    end

    def manga
      { uri: @uri, name: manga_name, site: site }
    end

    # Only valid chapters should be returned (using is_chapter?(uri))
    def chapter_list
      chapters = doc.css(@chapter_list_css).map { |a|
        uri = root + a[:href].sub(root, '')
        chapter = { uri: uri, name: a.text.strip, site: site }

        chapter if is_chapter?(chapter[:uri])
      }.compact
      @reverse_chapters ? chapters.reverse : chapters
    end

    def chapter
      { uri: @uri, 
        manga: manga_name, 
        name: chapter_name,
        chapter: chapter_number,
        site: site }
    end

    def page_list
      manga = manga_name
      number = chapter_number
      chapter = chapter_name

      (1..num_pages).map { |page|  
        uri_str = build_page_uri(manga, number, page)
        uri = Mangdown::Uri.new(uri_str).downcase 

        { uri: uri, name: page, chapter: chapter, manga: manga, site: site }
      }
    end

    private
    def page_image
      doc.css('img')[0]
    end

    def slug(string)
      string.gsub(' ', '-').gsub(/[:,]/, '')
    end
  end
end

