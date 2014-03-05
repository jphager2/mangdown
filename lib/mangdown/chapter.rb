module Mangdown
  class Chapter
    include ::Mangdown::Tools

    attr_reader :name, :pages, :uri, :num_pages
    
    def initialize( uri, name )
      @uri = uri
      @name = name
      @pages = []
      @root = get_root(@uri)

      get_pages
    end

    def download
      start_dir = Dir.pwd 
      Dir.mkdir(@name) unless Dir.exists?(@name)
      Dir.chdir(@name)
      
      @pages.each {|page| page.download}

      Dir.chdir(start_dir)
    end

    def get_pages
      uri = @uri
      get_doc(uri)
      @num_pages ||= get_num_pages
      
      @num_pages.times do
        page_uri, page_name = get_page 
        @pages << Page.new( page_uri, page_name )
        uri = get_next_uri
        get_doc(uri)
      end

      @doc = "Nokogiri::HTML::Document"
    end

    #def get_page # STAR
    #  image = @doc.css('img')[0]
    #  [image['src'], image['alt']]
    #end

    #def get_next_uri # STAR
    #  get_root(@uri) 
    #  @root + @doc.css('div#imgholder a')[0]['href']
    #end
  end

  class MRChapter < Chapter
    def get_page # STAR
      image = @doc.css('img')[0]
      [image['src'], image['alt']]
    end

    def get_next_uri # STAR
      @root + @doc.css('div#imgholder a')[0]['href']
    end

    def get_num_pages
      @doc.css('select')[1].children.length
    end
  end
end
