module Mangdown
  class Chapter

    attr_reader :pages

    # initialize with MDHash and only have @info[:key]
    def initialize(info)
      @info = info
      @pages = []

      get_pages
    end

    # reader method for uri
    def uri
      @info[:uri]
    end

    # reader method for name
    def name
      @info[:name]
    end

    # download should be in its own module
    # and the start_dir is sandwich code and should be moved and
    # passed a block 
    def download
			return_to_start_dir do 
				Dir.mkdir(@info[:name]) unless Dir.exists?(@info[:name])
				Dir.chdir(@info[:name])
				
				@pages.each {|page| page.download}
			end
    end

    private
      def get_pages
        uri = @info[:uri]
        doc = ::Mangdown::Tools.get_doc(uri)
        
        get_num_pages(doc).times do
          page = get_page(doc) 
          uri = get_next_uri(doc)

          @pages << Page.new(page)
          doc = ::Mangdown::Tools.get_doc(uri)
        end
      end
  end

  class MRChapter < Chapter
    private
      def get_page(doc)
        image = doc.css('img')[0]

        hash = MDHash.new
        hash[:uri], hash[:name] = image['src'], (image['alt'] + ".jpg")
        hash
      end

      def get_next_uri(doc)
        #root url + the href of the link to the next page
        ::Mangdown::Tools.get_root(@info[:uri]) + 
          doc.css('div#imgholder a')[0]['href']
      end

      def get_num_pages(doc)
        # the select is a dropdown menu of chapter pages
        doc.css('select')[1].children.length
      end
  end

  class MFChapter < Chapter
    private
      def get_page(doc)
        image = doc.css('img')[0]

        hash        = MDHash.new
        hash[:uri]  = image[:src]
        hash[:name] = image[:src].sub(/.+\//, '')
        hash
      end


      def get_next_uri(doc)
        root = @info[:uri].slice(/.+\//)
        root + doc.css('div#viewer a')[0][:href]
      end

      def get_num_pages(doc)
        doc.css('select')[1].children.length - 1
      end
  end
end
