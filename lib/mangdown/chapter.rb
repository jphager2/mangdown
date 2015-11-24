module Mangdown
	class Chapter

    include Equality
    include Enumerable

		attr_reader :uri, :pages

		def initialize(uri, name = nil, manga = nil, chapter = nil)
      # use a valid name
			@name = name 
      @manga = manga
      @chapter = chapter
			@uri = Mangdown::Uri.new(uri)
      @properties = Properties.new(@uri, nil, nil, name)

			load_pages
		end

    def name
      @name ||= @properties.chapter_name
    end

    def manga
       @manga ||= @properties.manga_name
    end

    def chapter
      @chapter ||= @properties.chapter_number
    end

    def inspect
      "#<#{self.class} @name=#{name} @uri=#{uri} " +
      "@pages=[#{pages.first(10).join(',')}"       +
      "#{",..." if pages.length > 10}]>"
    end
    alias_method :to_s, :inspect

    # enumerates through pages
    def each(&block)
      @pages.each(&block)
    end

		# explicit conversion to chapter
		def to_chapter
			self
		end

		# download all pages in a chapter
		def download_to(dir)
      dir   = Tools.relative_or_absolute_path(dir, @name)
      pages = map {|page| page.to_page}
      failed    = []
      succeeded = []

      Dir.mkdir(dir) unless Dir.exists?(dir)
      Tools.hydra_streaming(pages) do |stage, page, data=nil|
        case stage
        when :failed
          failed << page
        when :succeeded
          succeeded << page
        when :before
          path = page.file_path(dir)
          !File.exist?(path)
        when :body
          unless failed.include?(page)
            path = page.file_path(dir)
            File.open(path, 'ab') { |file| file.write(data) } 
          end
        when :complete
          unless failed.include?(page)
            path = page.file_path(dir)
            FileUtils.mv(path, "#{path}.#{Tools.file_type(path)}")
          end
        end
      end
      FileUtils.rm_rf(dir) if succeeded.empty?

      !succeeded.empty?
		end

		private
    def load_pages
			@pages ||= []
      fetch_each_page do |page| @pages << page end
      @pages.sort_by!(&:name)
    end

    # get page objects for all pages in a chapter
    def fetch_each_page
      pages = build_page_hashes
      Tools.hydra(pages) do |page, body|
        page = get_page(page.uri, Nokogiri::HTML(body))
        yield(page)
      end
    end

    # get the docs for number of pages 
    def build_page_hashes
      (1..@properties.num_pages).map { |num|  
        uri_str = @properties.build_page_uri(uri, manga, chapter, num)
        MDHash.new(uri: Mangdown::Uri.new(uri_str).downcase, name: num)
      }
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
