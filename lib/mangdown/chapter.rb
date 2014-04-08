module Mangdown
	class Chapter

		attr_reader :name, :uri, :pages

		def initialize(name, uri)
			@name  = name
			@uri   = Mangdown::Uri.new(uri)
			@pages = []

			get_pages
		end

		# explicit conversion to chapter
		def to_chapter
			self
		end

		# download should be in its own module
		# download all pages in a chapter
		def download
			Tools.return_to_start_dir do 
				Dir.mkdir(@name) unless Dir.exists?(@name)
				Dir.chdir(@name)
				
				@pages.each {|page| page.download}
			end
		end

		private
			
			# get page objects for all pages in a chapter
			def get_pages
				doc = Tools.get_doc(@uri)
				
				get_num_pages(doc).times do
					hash = get_page(doc) 
					uri = get_next_uri(doc)

					@pages << hash.to_page 
					doc = Tools.get_doc(uri)
				end
			end
	end

	# mangareader chapter object
	class MRChapter < Chapter
		private
			
			# get the page uri and name
			def get_page(doc)
				image = doc.css('img')[0]

				MDHash.new(
					uri: image['src'], 
					name: (image['alt'] + ".jpg")
				)
			end

			# get the next document uri
			def get_next_uri(doc)
				#root url + the href of the link to the next page
				Tools.get_root(@uri) << 
					doc.css('div#imgholder a')[0]['href']
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

			# get the page name and uri
			def get_page(doc)
				image = doc.css('img')[0]

				MDHash.new(
					uri: image[:src], 
					name: image[:src].sub(/.+\//, '')
				)
			end

			# get the next document uri
			def get_next_uri(doc)
				@uri.slice(/.+\//) <<                   # different from root
					doc.css('div#viewer a')[0][:href]
			end

			# get the number of pages
			def get_num_pages(doc)
				doc.css('select')[1].children.length - 1
			end
	end
end
