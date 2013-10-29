module Mandown
  class Chapter
		include ::Mandown::Tools

    attr_reader :name, :pages, :uri
    
    def initialize( uri, name )
      @uri = uri
      @name = name
      @pages = []
      
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

      while get_chapter_mark == @name do
        page_uri, page_name = get_page 
        @pages << Page.new( page_uri, page_name )
        uri = get_next_uri
        get_doc(uri)
      end

      @doc = "Nokogiri::HTML::Document"
    end

    #def get_chapter_mark # STAR
     # @doc.css('title').text.slice(/([\w|\s]+)?/).strip
    #end

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
    def get_chapter_mark # STAR
      @doc.css('title').text.slice(/([\w|\s]+)?/).strip
    end
    
    def get_page # STAR
      image = @doc.css('img')[0]
      [image['src'], image['alt']]
    end

    def get_next_uri # STAR
      get_root(@uri) 
      @root + @doc.css('div#imgholder a')[0]['href']
    end
  end
end  
