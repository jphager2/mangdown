require 'progress_bar'

module Mangdown

  DOWNLOAD_DIR ||= Dir.home + '/manga'

	# mangdown manga object, which holds chapters
  class Manga

    include Equality
    include Enumerable
    attr_reader :name, :uri, :chapters, :enum 

    def initialize(name, uri)
			@name = name
			@uri  = Mangdown::Uri.new(uri)
      @chapters = []
      @properties = Properties.new(uri)

      get_chapters
    end

    def inspect
      "#<#{self.class} @name=#{name} @uri=#{uri} " +
      "@chapters=[#{chapters.first(10).join(',')}" +
      "#{",..." if chapters.length > 10}]>"
    end
    alias_method :to_s, :inspect

    # download to current directory convenience method
    def download(*args)
      download_to(DOWNLOAD_DIR,*args)
    end
    
    # download using enumerable
    def download_to(dir, start = 0, stop = -1)
      start, stop = validate_indeces!(start, stop)
      dir         = setup_download_dir!(dir)

      bar = progress_bar(start, stop)
      reset(start, stop)
      loop do
        self.next.to_chapter.download_to(dir)
        bar.increment!
      end
    end

    # explicit conversion to manga
    def to_manga 
      self
    end

    # each for enumerating through chapters
    def each
      @chapters.each {|chapter| yield(chapter) if block_given?}
    end 

    # go through the chapters one at a time
    def next
      @enum || reset
      @enum.next
    end

    private
    # reset enum for next
    def reset(start = 0, stop = -1)
      @enum = each[start..stop].lazy
    end

    # get push MDHashes of manga chapters to @chapters 
    def get_chapters
      @chapters += @properties.manga_chapters do |uri, name, site|
         MDHash.new(uri: uri, name: name, site: site)
      end
    end

    def chapter_indeces(start, stop)
      [chapters.index(chapters[start]), chapters.index(chapters[stop])]
    end

    def setup_download_dir!(dir)
      "#{dir}/#{name}".tap {|dir| Dir.mkdir(dir) unless Dir.exist?(dir)}
    end

    def validate_indeces!(start, stop)
      i_start, i_stop = chapter_indeces(start, stop)
      if i_stop < i_stop
        error = 'Last index must be greater than first index'
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
