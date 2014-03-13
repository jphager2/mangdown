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
			root = Properties.new(@info[:uri]).root
			css_klass = Properties.new(root).manga_css_klass 

      #get the link with chapter name and uri
      doc.css(css_klass).each do |chapter|
				@chapters_list << MDHash.new(
					uri: (root + chapter[:href].sub(root, '')) 
					name: chapter.text) 
      end

      if root =~ /mangafox/
        @chapters_list.reverse!
      end
    end

    # chapter is an MDHash
    def chapter_found(chapter)
      @chapters.find do |chp| 
        (chp.name == chapter[:name]) or (chp.uri == chapter[:uri])
      end
    end

    def get_chapter(index) 
      chapter  = @chapters_list[index] 

      unless chapter_found(chapter) 
				@chapters << Properties.new(
					           @info[:uri]).chapter_klass.new(chapter)
      else
        puts "This chapter has already been added" 
      end
    end
  end
end
