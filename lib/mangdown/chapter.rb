module Mangdown
  class Chapter

    include Equality
    include Enumerable

    attr_reader :uri, :pages, :name, :manga, :chapter
    attr_accessor :adapter

    def initialize(uri, name, manga, chapter = nil)
      @name = name 
      @manga = manga
      @chapter = chapter
      @uri = Mangdown::Uri.new(uri)
      @pages = []
    end

    def inspect
      "#<#{self.class} @name=#{name} @uri=#{uri} " +
      "@pages=[#{pages.first(3).join(',')}"       +
      "#{",..." if pages.length > 3}]>"
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

    def to_path
      @path ||= set_path
    end

    def set_path(dir = nil)
      dir ||= File.join(DOWNLOAD_DIR, manga)
      path = File.join(dir, name)
      path = Tools.valid_path_name(path)
      @path = Tools.relative_or_absolute_path(path)
    end

    def cbz(dir = to_path)
      CBZ.one(dir)
    end

    # download all pages in a chapter
    def download_to(dir = nil, opts = { force_download: false })
      pages = map(&:to_page)
      failed = []
      succeeded = []
      skipped = []

      setup_download_dir!(dir)
      if opts[:force_download]
        FileUtils.rm_r(to_path)
        setup_download_dir!(dir)
      end

      Tools.hydra_streaming(pages) do |stage, page, data = nil|
        case stage
        when :failed
          failed << page
        when :succeeded
          succeeded << page
        when :before
          !(page.file_exist?(to_path) && skipped << page)
        when :body
          page.append_file_data(to_path, data) unless failed.include?(page)
        when :complete
          page.append_file_ext(to_path) unless failed.include?(page)
        end
      end

      FileUtils.rm_r(to_path) if succeeded.empty? && skipped.empty?

      { failed: failed, succeeded: succeeded, skipped: skipped }
    end

    def load_pages
      return @pages if @pages.any?

      fetch_each_page do |page| @pages << page end
      @pages.sort_by!(&:name)
    end

    private
    def setup_download_dir!(dir)
      set_path(dir)
      FileUtils.mkdir_p(to_path) unless Dir.exists?(to_path)
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
      adapter.page_list.map { |page|
        page.merge!(chapter: name, manga: manga)
        MDHash.new(page) }
    end

    # get the page name and uri
    def get_page(uri, doc)
      # Local binding for adapter
      adapter = Mangdown.adapter!(uri, nil, doc)
      uri = adapter.page_image_src 
      page = adapter.page_image_name
      site = adapter.site

      MDHash.new(
        uri: uri, name: page, chapter: name, manga: manga, site: site)
    end
  end
end
