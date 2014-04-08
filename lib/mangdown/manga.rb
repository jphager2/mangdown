module Mangdown

	# mangdown manga object, which holds chapters
  class Manga

    attr_reader :name, :uri, :chapters, :chapters_list 

    def initialize(name, uri)
			@name = name
			@uri  = uri

      #Keeping these chapter objects in memory could be expensive
      @chapters = []
      @chapters_list = []

      get_chapters_list
    end

		# explicit conversion to manga
		def to_manga 
			self
		end

		# get push MDHashes of manga chapters to @chapters 
    def get_chapters_list
			properties = Properties.new(@uri)
      doc        = Tools.get_doc(@uri)
			root       = properties.root

      #get the link with chapter name and uri
      doc.css(properties.manga_css_klass).each do |chapter|
				@chapters_list << MDHash.new(
					uri: (root + chapter[:href].sub(root, '')), 
					name: chapter.text
				) 
      end

			@chapters_list.reverse! if properties.reverse 
    end

    # returns a MDHash if the chapter is found in @chapters 
    def chapter_found(chapter)
      @chapters.find do |chp| 
        (chp.name == chapter[:name]) or (chp.uri == chapter[:uri])
      end
    end

		# pushes a Chapter object into @chapters unless it is already there
    def get_chapter(index) 
      chapter  = @chapters_list[index] 

      unless chapter_found(chapter) 
				@chapters << chapter.to_chapter 
      else
        puts "This chapter has already been added" 
      end
    end
  end
end
