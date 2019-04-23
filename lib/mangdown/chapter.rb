# frozen_string_literal: true

module Mangdown
  # Mangdown chapter object, which holds pages
  class Chapter
    extend Forwardable

    include Equality

    attr_reader :chapter

    def_delegators :chapter, :url, :name, :number

    alias uri url

    def initialize(chapter)
      @chapter = chapter
    end

    def pages
      @pages ||= chapter.pages.map { |page| Mangdown.page(page) }
    end

    def manga
      @manga ||= Mangdown.manga(chapter.manga)
    end

    def path
      @path ||= setup_path
    end
    alias to_path path

    def setup_path(dir = nil)
      dir ||= manga.path
      path = Tools.file_join(dir, name)
      path = Tools.valid_path_name(path)
      @path = Tools.relative_or_absolute_path(path)
    end

    def cbz(dir = to_path)
      CBZ.one(dir)
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/PerceivedComplexity
    def download_to(dir = nil, opts = { force_download: false })
      failed = []
      succeeded = []
      skipped = []

      setup_download_dir!(dir)
      if opts[:force_download]
        FileUtils.rm_r(to_path)
        setup_download_dir!(dir)
      end

      Tools.hydra_streaming(
        pages,
        chapter.hydra_opts
      ) do |stage, page, data = nil|
        case stage
        when :failed
          failed << [page, data]
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
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/PerceivedComplexity

    private

    def setup_download_dir!(dir)
      setup_path(dir)
      FileUtils.mkdir_p(to_path) unless Dir.exist?(to_path)
    end
  end
end
