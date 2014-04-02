module Mangdown

	# mangdown manga object, which holds chapters
  class Manga

    attr_reader :chapters, :chapters_list 

    #initialize only use @info[:key]
    def initialize(info)
      @info = info

      #Keeping these chapter objects in memory could be expensive
      @chapters = []
      @chapters_list = []

      get_chapters_list
    end

		# get push MDHashes of manga chapters to @chapters 
    def get_chapters_list
			properties = Properties.new(@info[:uri])
      doc        = Tools.get_doc(@info[:uri])
			root       = properties.root

      #get the link with chapter name and uri
      doc.css(properties.manga_css_klass).each do |chapter|
				@chapters_list << MDHash.new(
					uri: (root + chapter[:href].sub(root, '')), 
					name: chapter.text) 
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
				@chapters << 
				Properties.new(@info[:uri]).chapter_klass.new(chapter)
      else
        puts "This chapter has already been added" 
      end
    end
		
		# empties @chapters
		def remove_chapters
      @chapters = []
		end

		private
			# dot access to hash values
			def method_missing(method, *args, &block) 
				return @info[method] unless @info[method].nil?
				super
			end
  end
end
