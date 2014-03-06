module Mangdown
  class Manga
    include ::Mangdown::Tools

    attr_reader :chapters, :chapters_list, :name, :uri

    #initialize with MDHash instead and only use @info[:key]
    def initialize(uri, name)
      @uri = uri
      @name = name

      #Keeping these chapter objects in memory could be expensive
      @chapters = []
      @chapters_list = []

      get_chapters_list
    end

    def get_chapters_list
      doc = ::Mangdown::Tools.get_doc(@uri)
      root = ::Mangdown::Tools.get_root(@uri)


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

    def get_chapter(index) 
      
      root = ::Mangdown::Tools.get_root(@uri)
      uri  = @chapters_list[index][:uri] 
      name = @chapters_list[index][:name]
    
      unless @chapters.find {|chp| (chp.name == name) or (chp.uri == uri)}
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
     
        @chapters << chapter_klass.new(uri, name)
      else
        puts "This chapter has already been added" 
      end
    end
  end
end
