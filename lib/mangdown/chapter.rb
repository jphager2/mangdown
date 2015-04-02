module Mangdown
	class Chapter

    include Equality
    include Enumerable
		attr_reader :name, :uri, :pages, :manga, :chapter

		def initialize(name, uri)
      # use a valid name
			@name       = name.sub(/\s(\d+)$/) { |num| 
        ' ' + num.to_i.to_s.rjust(3, '0')
      }
      @manga      = name.slice(/(^.+)\s/, 1) 
      @chapter    = name.slice(/\d+\z/).to_i 
			@uri        = Mangdown::Uri.new(uri)
      @properties = Properties.new(@uri)
			@pages      = []

			get_pages
      @pages.sort_by! {|page| page.name}
		end

    def inspect
      "#<#{self.class} @name=#{name} @uri=#{uri} " +
      "@pages=[#{pages.first(10).join(',')}"       +
      "#{",..." if pages.length > 10}]>"
    end
    alias_method :to_s, :inspect

    # enumerates through pages
    def each
      block_given? ? @pages.each { |page| yield(page) } : @pages.each
    end

		# explicit conversion to chapter
		def to_chapter
			self
		end

		# download all pages in a chapter
		def download_to(dir)
      dir = Tools.relative_or_absolute_path(dir, @name)
      Dir.mkdir(dir) unless Dir.exists?(dir)
      
      Tools.hydra(map { |page| page.to_page }) do |page, data|
        next if File.exist?(path = page.file_path(dir))
        File.open(path, 'wb') { |file| file.write(data) }
      end
		end

		private
    # get page objects for all pages in a chapter
    def get_pages
      pages = (1..get_num_pages(Tools.get_doc(uri)))
        .map { |num| get_page_hash(num) }

      Tools.hydra(pages) do |page, body|
        @pages << get_page(Nokogiri::HTML(body))
      end
    end

    # get the number of pages in a chapter
    def get_num_pages(doc)
      # the select is a dropdown menu of chapter pages
      doc.css('select')[1].css('option').length
    end	

  end

	# mangareader chapter object
	class MRChapter < Chapter
		private
      # get the doc for a given page number
      def get_page_hash(num)
        root     = @properties.root
        manga    = @manga.gsub(' ', '-')
        uri_str  = "#{root}/#{manga}/#{@chapter}/#{num}"

        MDHash.new(
          uri: Mangdown::Uri.new(uri_str).downcase, name: num
        )
      end
		
			# get the page uri and name
			def get_page(doc)
				image = doc.css('img')[0]

				MDHash.new(
					uri: image['src'], 
					name: (image['alt'] + ".jpg"),
          site: @properties.type,
        )
			end
	end

	# mangafox chapter object
	class MFChapter < Chapter
		private
    # get the doc for a given page number
    def get_page_hash(num)
      uri_str = uri.sub(/\d+\.html/, "#{num}.html")

      MDHash.new(
        uri: Mangdown::Uri.new(uri_str).downcase, name: num
      )
    end

    # get the page name and uri
    def get_page(doc)
      image = doc.css('img')[0]

      MDHash.new(
        uri: image[:src], 
        name: image[:src].sub(/.+\//, ''),
        site: @properties.type,
      )
    end

    # get the number of pages
    def get_num_pages(doc)
      super - 1
    end
	end
end
