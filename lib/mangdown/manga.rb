module Mangdown
  class Manga
    include ::Mangdown::Tools

    attr_reader :chapters, :chapters_list 

    #initialize only use @info[:key]
    def initialize(info)
      @info = info

      #Keeping these chapter objects in memory could be expensive
      @chapters = []
      @chapters_list = []

      get_chapters_list
    end

    # reader method for uri
    def uri
      @info[:uri]
    end

    # reader method for name
    def name
      @info[:name]
    end

    def get_chapters_list
      doc = ::Mangdown::Tools.get_doc(@info[:uri])
      root = ::Mangdown::Tools.get_root(@info[:uri])


      #get the link with chapter name and uri
      doc.css(css_klass(root)).each do |chapter|
        hash = MDHash.new
        hash[:uri], hash[:name] = (root + chapter[:href]), chapter.text
        @chapters_list << hash 
      end
    end
 
    def css_klass(site)
      case site
      when /mangareader/
        'div#chapterlist td a'
      when /mangafox/
        'a.tips'
      else
        nil
      end
    end

    # chapter is an MDHash
    def chapter_found(chapter)
      @chapters.find do |chp| 
        (chp.name == chapter[:name]) or (chp.uri == chapter[:uri])
      end
    end

    def get_chapter(index) 
      
      root = ::Mangdown::Tools.get_root(@info[:uri])
      chapter  = @chapters_list[index] 

      unless chapter_found(chapter) 
        # this should be put in a module the case is used in 
        # almost every class
        chapter_klass = case root 
        when /mangareader/
          MRChapter
        when /mangafox/
          MKChapter
        else
          NO_Chapter
        end
     
        @chapters << chapter_klass.new(chapter)
      else
        puts "This chapter has already been added" 
      end
    end
  end
end
