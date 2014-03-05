module Mangdown
  class Manga
    include ::Mangdown::Tools

    attr_reader :chapters, :chapters_list, :name, :uri

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
      doc.css('div#chapterlist td a').each do |chapter|
        @chapters_list << ([root + chapter['href'], chapter.text])
      end
    end
 
    def get_chapter(index) 
      
      root = ::Mangdown::Tools.get_root(@uri)
      uri, name = @chapters_list[index]
    
      unless @chapters.find {|chp| (chp.name == name) or (chp.uri == uri)}
        # this is far from ideal
        chapter_klass = if root.include?('mangareader')
          MRChapter
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
