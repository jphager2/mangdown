module Mangdown
  # mangdown manga object, which holds chapters
  class Manga
    include Equality
    include Enumerable

    attr_reader :uri, :chapters, :name
    attr_accessor :adapter

    def initialize(uri, name)
      @name = name
      @uri = URI.escape(uri)
      @chapters = []
    end

    def inspect
      "#<#{self.class} @name=#{name} @uri=#{uri} " +
      "@chapters=[#{chapters.first(3).join(',')}" +
      "#{",..." if chapters.length > 3}]>"
    end
    alias_method :to_s, :inspect

    def cbz
      CBZ.all(to_path)
    end

    def download(*args)
      download_to(nil, *args)
    end
    
    # download using enumerable
    def download_to(dir, start = 0, stop = -1, opts = { force_download: false })
      start, stop = validate_indeces!(start, stop)
      setup_download_dir!(dir)
      failed = []
      succeeded = []
      skipped = []

      chapters[start..stop].each do |md_hash|
        chapter = md_hash.to_chapter
        chapter_result = chapter.download_to(to_path, opts)
        
        if chapter_result[:failed].any?
          failed << chapter
        elsif chapter_result[:succeeded].any?
          succeeded << chapter
        elsif chapter_result[:skipped].any?
          skipped << chapter
        end
        if chapter_result[:failed].any?
          STDERR.puts("error: #{chapter.name} was not fully downloaded") 
        else
          bar.increment!
        end
      end
      { failed: failed, succeeded: succeeded, skipped: skipped }
    end

    def to_manga 
      self
    end

    def to_path
      @path ||= set_path
    end

    def set_path(dir = nil)
      dir ||= DOWNLOAD_DIR 
      path = File.join(dir, name)
      @path = Tools.relative_or_absolute_path(path)
    end

    def each(&block)
      @chapters.each(&block)
    end 

    def load_chapters
      @chapters += adapter.chapter_list.map do |chapter|
         chapter.merge!(manga: name)
         MDHash.new(chapter)
      end
    end

    private

    def chapter_indeces(start, stop)
      length = chapters.length
      [start, stop].map { |i| i < 0 ? length + i : i }
    end

    def setup_download_dir!(dir)
      set_path(dir) 
      FileUtils.mkdir_p(to_path) unless Dir.exist?(to_path)
    end

    def validate_indeces!(start, stop)
      chapter_indeces(start, stop).tap { |i_start, i_stop|
        last = chapters.length - 1

        if i_start > last || i_stop > last
          error = "This manga has chapters in the range (0..#{last})"
          raise ArgumentError, error
        elsif i_stop < i_start
          error = 'Last index must be greater than or equal to first index'
          raise ArgumentError, error
        end 
      }
    end
  end
end
