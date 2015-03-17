module Mangdown
	class Chapter

    include Equality
    include Enumerable
		attr_reader :name, :uri, :pages, :manga, :chapter

		def initialize(name, uri)
      # use a valid name
			@name       = name.sub(/\s(\d+)$/) { |num| 
        ' ' + num.to_i.to_s.rjust(3, '0')
      }
      @manga      = name.slice(/(^.+)\s/, 1) 
      @chapter    = name.slice(/\d+\z/).to_i 
			@uri        = Mangdown::Uri.new(uri)
      @properties = Properties.new(@uri)
			@pages      = []

			get_pages
      @pages.sort_by! {|page| page.name}
		end

    # enumerates through pages
    def each
      block_given? ? @pages.each { |page| yield(page) } : @pages.each
    end

		# explicit conversion to chapter
		def to_chapter
			self
		end

		# download all pages in a chapter
		def download_to(dir)
      dir = File.expand_path(dir + '/' + @name)
      Dir.mkdir(dir) unless Dir.exists?(dir)
      
      threads = []
      each do |page| 
        threads << Thread.new(page) do |this_page| 
          this_page.to_page.download_to(dir)
        end
      end

      threads.each {|thread| thread.join}
		end

		private
			# get page objects for all pages in a chapter
			def get_pages
        threads = []

        num_pages = get_num_pages(Tools.get_doc(uri))
        1.upto(num_pages) do |num|
          threads << Thread.new(num) do |this_num|
            Tools.no_time_out do
              tries = 0
              until doc = get_page_doc(this_num) || tries > 2
                tries += 1
              end
              return unless doc
              @pages << get_page(doc)
            end
          end
        end

        threads.each {|thread| thread.join}
			end

      # get the number of pages in a chapter
			def get_num_pages(doc)
				# the select is a dropdown menu of chapter pages
        doc.css('select')[1].css('option').length
			end	

  end

	# mangareader chapter object
	class MRChapter < Chapter
		private
      # get the doc for a given page number
      def get_page_doc(num)
        root     = @properties.root
        manga    = @manga.gsub(' ', '-')
        uri_str  = "#{root}/#{manga}/#{@chapter}/#{num}"
        page_uri = Mangdown::Uri.new(uri_str).downcase

        Tools.get_doc(page_uri)
      rescue SocketError => error 
        STDERR.puts( "#{error.message} | #{name} | #{num}" )
      end
		
			# get the page uri and name
			def get_page(doc)
				image = doc.css('img')[0]

				MDHash.new(
					uri: image['src'], 
					name: (image['alt'] + ".jpg"),
          site: @properties.type,
        )
      rescue NoMethodError => error
        puts 'doc was ' + doc.class
			end
	end

	# mangafox chapter object
	class MFChapter < Chapter
		private
      # get the doc for a given page number
      def get_page_doc(num)
        Tools.get_doc(
          Mangdown::Uri.new(
            @properties.root                                + 
            "/manga/#{@manga.gsub(' ', '_')}/c#{@chapter}/" + 
            "#{num}.html"
          ).downcase
        )
      rescue SocketError => error 
        STDERR.puts( "#{error.message} | #{name} | #{num}" )
      end

			# get the page name and uri
			def get_page(doc)
				image = doc.css('img')[0]

				MDHash.new(
					uri: image[:src], 
					name: image[:src].sub(/.+\//, ''),
          site: @properties.type,
        )
			end

			# get the number of pages
			def get_num_pages(doc)
        super - 1
			end
	end
end
