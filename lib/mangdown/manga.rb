module Mangdown

  DOWNLOAD_DIR ||= Dir.home + '/manga'

	# mangdown manga object, which holds chapters
  class Manga

    include Enumerable
    attr_reader :name, :uri, :chapters, :enum 

    def initialize(name, uri)
			@name = name
			@uri  = uri
      @chapters = []

      get_chapters
    end

    public 
      # download to current directory convenience method
      def download(*args)
        download_to(DOWNLOAD_DIR,*args)
      end
      
      # download using enumerable
      def download_to(dir, start = 0, stop = -1)
        dir += "/#{name}"
        reset(start, stop)
        Dir.mkdir(dir) unless Dir.exist?(dir)
        loop do
          self.next.to_chapter.download_to(dir)
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

      # reset enum for next
      def reset(start = 0, stop = -1)
        @enum = each[start..stop].lazy
      end
  
      # get push MDHashes of manga chapters to @chapters 
      def get_chapters
        properties = Properties.new(@uri)
        doc        = Tools.get_doc(@uri)
        root       = properties.root

        #get the link with chapter name and uri
        doc.css(properties.manga_css_klass).each do |chapter|
          @chapters << MDHash.new(
            uri: (root + chapter[:href].sub(root, '')), 
            name: chapter.text,
          ) 
        end

        @chapters.reverse! if properties.reverse 
      end
  end
end
