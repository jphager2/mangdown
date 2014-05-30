module Mangdown
	class Chapter

		attr_reader :name, :uri, :pages

		def initialize(name, uri)
      @manga = name.slice(/(^.+)\s/, 1) 
      @chapter = name.slice(/\d+\z/) 
			@name  = name
			@uri   = Mangdown::Uri.new(uri)
			@pages = []
      @properties = Properties.new(@uri)

			get_pages
		end

		# explicit conversion to chapter
		def to_chapter
			self
		end

		# download should be in its own module
		# download all pages in a chapter
		def download
      dir = File.expand_path(@name)
      Dir.mkdir(dir) unless Dir.exists?(dir)
      
      threads = []
      @pages.each do |page| 
        threads << Thread.new(page) do |this_page| 
          this_page.download_to(dir)
        end
      end

      threads.each {|thread| thread.join}
      return @pages.length
		end

		private
			
			# get page objects for all pages in a chapter
			def get_pages
        threads = []
        get_num_pages(get_page_doc(1)).times do |page|
          threads << Thread.new(page) do |this_page|
            hash = get_page(get_page_doc(this_page + 1)) 
            @pages << hash.to_page 
          end
				end

        threads.each {|thread| thread.join}
        return @pages.length
			end
	end

	# mangareader chapter object
	class MRChapter < Chapter
		private
	
      # get the doc for a given page number
      def get_page_doc(num)
        doc = Tools.get_doc(
          Mangdown::Uri.new( 
            @properties.root                                + 
            "/#{@manga.gsub(' ', '-')}/#{@chapter}/#{num}"
          ).downcase
        )
      end
		
			# get the page uri and name
			def get_page(doc)
				image = doc.css('img')[0]

				MDHash.new(
					uri: image['src'], 
					name: (image['alt'] + ".jpg")
				)
			end

			# get the number of pages
			def get_num_pages(doc)
				# the select is a dropdown menu of chapter pages
        doc.css('select')[1].children.length
			end
	end

	# mangafox chapter object
	class MFChapter < Chapter
		private

      # get the doc for a given page number
      def get_page_doc(num)
        doc = Tools.get_doc(
          Mangdown::Uri.new(
            @properties.root                               + 
            "/manga/#{@manga.gsub(' ', '_')}/c#{@chapter}/" + 
            "#{num}.html"
          ).downcase
        )
      end

			# get the page name and uri
			def get_page(doc)
				image = doc.css('img')[0]

				MDHash.new(
					uri: image[:src], 
					name: image[:src].sub(/.+\//, '')
				)
			end

			# get the number of pages
			def get_num_pages(doc)
				doc.css('select')[1].children.length - 1
			end
	end
end
