require 'progress_bar'

module Mangdown

  DOWNLOAD_DIR ||= Dir.home + '/manga'

	# mangdown manga object, which holds chapters
  class Manga

    include Equality
    include Enumerable
    attr_reader :uri, :chapters

    def initialize(name = nil, uri)
      @name = name
			@uri = Mangdown::Uri.new(uri)
      @chapters = []
      @properties = Properties.new(uri)

      get_chapters
    end

    def name
      @name || @properties.manga_name
    end

    def inspect
      "#<#{self.class} @name=#{name} @uri=#{uri} " +
      "@chapters=[#{chapters.first(10).join(',')}" +
      "#{",..." if chapters.length > 10}]>"
    end
    alias_method :to_s, :inspect

    # download to current directory convenience method
    def download(*args)
      download_to(DOWNLOAD_DIR, *args)
    end
    
    # download using enumerable
    def download_to(dir, start = 0, stop = -1)
      start, stop = validate_indeces!(start, stop)
      dir         = setup_download_dir!(dir)

      bar = progress_bar(start, stop)
      chapters.each do |md_hash|
        chapter = md_hash.to_chapter
        if chapter.download_to(dir)
          bar.increment!
        else
          STDERR.puts("error: #{chapter.name} was not downloaded") 
        end
      end
    end

    # explicit conversion to manga
    def to_manga 
      self
    end

    # each for enumerating through chapters
    def each(&block)
      @chapters.each(&block)
    end 

    private
    # push MDHashes of manga chapters to @chapters 
    def get_chapters
      @chapters += @properties.manga_chapters do |uri, name, site|
         MDHash.new(uri: uri, name: name, site: site)
      end
    end

    def chapter_indeces(start, stop)
      length = chapters.length
      [start, stop].map { |i| i < 0 ? length + i : i }
    end

    def setup_download_dir!(dir)
      "#{dir}/#{name}".tap { |dir| Dir.mkdir(dir) unless Dir.exist?(dir) }
    end

    def validate_indeces!(start, stop)
      i_start, i_stop = chapter_indeces(start, stop)
      if i_start.nil? || i_stop.nil?
        last  = chapters.length - 1
        error = "This manga has chapters in the range (0..#{last})"
        raise ArgumentError, error
      elsif i_stop < i_start
        error = 'Last index must be greater than or equal to first index'
        raise ArgumentError, error
      end 
      [i_start, i_stop]
    end

    # create a progress bar object for start and stop indexes
    def progress_bar(start, stop)
      ProgressBar.new(stop - start + 1)
    end
  end
end
