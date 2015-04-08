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
      dir   = Tools.relative_or_absolute_path(dir, @name)
      pages = map {|page| page.to_page}

      Dir.mkdir(dir) unless Dir.exists?(dir)
      Tools.hydra_streaming(pages) do |stage, page, data=nil|
        path = page.file_path(dir)
        case stage
        when :before
          !File.exist?(path)
        when :body
          File.open(path, 'ab') { |file| file.write(data) } 
        when :complete
          FileUtils.mv(path, "#{path}.#{Tools.file_type(path)}")
        end
      end
		end

		private
    # get page objects for all pages in a chapter
    def get_pages
      pages = (1..@properties.num_pages).map {|num| get_page_hash(num)}

      Tools.hydra(pages) do |page, body|
        @pages << get_page(page.uri, Nokogiri::HTML(body))
      end
    end

    # get the doc for a given page number
    def get_page_hash(num)
      uri_str = @properties.build_page_uri(uri, @manga, @chapter, num)

      MDHash.new(
        uri: Mangdown::Uri.new(uri_str).downcase, name: num
      )
    end

    # get the page name and uri
    def get_page(uri, doc)
      properties = Properties.new(uri, nil, doc)
      MDHash.new(
        uri:  properties.page_image_src, 
        name: properties.page_image_name,
        site: properties.type
      )
    end
  end
end
