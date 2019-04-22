# frozen_string_literal: true

module Mangdown
  # Mangdown manga object, which holds chapters
  class Manga
    extend Forwardable

    include Equality
    include Enumerable
    include Logging

    attr_accessor :manga

    def_delegators :manga, :url, :name

    alias uri url

    def initialize(manga)
      @manga = manga
    end

    def chapters
      @chapters ||= manga
                    .chapters
                    .map { |chapter| Mangdown.chapter(chapter) }
    end

    def cbz
      CBZ.all(to_path)
    end

    def download(*args)
      download_to(nil, *args)
    end

    def download_to(dir, start = 0, stop = -1, opts = { force_download: false })
      start, stop = validate_indeces!(start, stop)
      setup_download_dir!(dir)
      failed = []
      succeeded = []
      skipped = []

      chapters[start..stop].each do |chapter|
        chapter_result = chapter.download_to(to_path, opts)

        if chapter_result[:failed].any?
          failed << [chapter, chapter_result]
        elsif chapter_result[:succeeded].any?
          succeeded << [chapter, chapter_result]
        elsif chapter_result[:skipped].any?
          skipped << [chapter, chapter_result]
        end

        next unless chapter_result[:failed].any?

        logger.error({
          msg: 'Chapter was not fully downloaded',
          uri: chapter.uri,
          chapter: chapter.name
        }.to_s)
      end

      { failed: failed, succeeded: succeeded, skipped: skipped }
    end

    def path
      @path ||= setup_path
    end
    alias to_path path

    def setup_path(dir = nil)
      dir ||= DOWNLOAD_DIR
      path = File.join(dir, name)
      @path = Tools.relative_or_absolute_path(path)
    end

    private

    def chapter_indeces(start, stop)
      length = chapters.length
      [start, stop].map { |i| i.negative? ? length + i : i }
    end

    def setup_download_dir!(dir)
      setup_path(dir)
      FileUtils.mkdir_p(to_path) unless Dir.exist?(to_path)
    end

    def validate_indeces!(start, stop)
      chapter_indeces(start, stop).tap do |i_start, i_stop|
        last = chapters.length - 1

        if i_start > last || i_stop > last
          error = "This manga has chapters in the range (0..#{last})"
          raise Mangdown::Error, error
        elsif i_stop < i_start
          error = 'Last index must be greater than or equal to first index'
          raise Mangdown::Error, error
        end
      end
    end
  end
end
