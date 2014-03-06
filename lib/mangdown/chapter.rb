module Mangdown
  class Chapter

    attr_reader :name, :pages, :uri

    # initialize with MDHash and only have @info[:key]
    def initialize( uri, name )
      @uri = uri
      @name = name
      @pages = []

      get_pages
    end

    # download should be in its own module
    def download
      start_dir = Dir.pwd 

      Dir.mkdir(@name) unless Dir.exists?(@name)
      Dir.chdir(@name)
      
      @pages.each {|page| page.download}

      Dir.chdir(start_dir)
    end

    private
      def get_pages
        uri = @uri
        doc = ::Mangdown::Tools.get_doc(uri)
        
        get_num_pages(doc).times do
          page_uri, page_name = get_page(doc) 
          uri = get_next_uri(doc)

          @pages << Page.new( page_uri, page_name )
          doc = ::Mangdown::Tools.get_doc(uri)
        end
      end
  end

  class MRChapter < Chapter
    private
      def get_page(doc)
        image = doc.css('img')[0]
        [image['src'], image['alt']]
      end

      def get_next_uri(doc)
        #root url + the href of the link to the next page
        ::Mangdown::Tools.get_root(@uri) + 
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
        [image['src'], image['alt']]
      end

      def get_next_uri(doc)
        root = @uri.slice(/.+\//)
        root + doc.css('div#viewer a')[0][:href]
      end

      def get_num_pages(doc)
        doc.css('select')[1].children.length - 1
      end
  end
end
