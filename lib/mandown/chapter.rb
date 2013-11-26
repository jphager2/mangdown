module Mandown
  class Chapter
		include ::Mandown::Tools

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

  class FKChapter < Chapter
    attr_reader :num_pages

    def initialize(uri, name, num_pages)
      @num_pages = num_pages

      super(uri, name)
    end

=begin
    def get_pages
      uri = @uri
      get_doc(uri)

      @num_pages.times do
        page_uri, page_name = get_page 
        @pages << Page.new( page_uri, page_name )
        uri = get_next_uri
        get_doc(uri)
      end

      @doc = "Nokogiri::HTML::Document"
    end
=end

    def get_page # STAR
      page = (@pages.length + 1).to_s
      while page.length < 3
        page = '0' + page
      end

      # puts "Doc: #{@doc.css('script').text.length}"
      # 
      # It seems that Nokogiri cuts out the spaces that were previously there
      # before
      #
      # Watch this because I'm guessing this might revert back
      # 
       script = @doc.css('script').text

       if script.include?(" + x + ")
         s = /(http:\/\/t\.fakku\.net)(.+?)('\s\+\sx\s\+\s')(\.jpg)/
       else
         s = /(http:\/\/t\.fakku\.net)(.+?)('\+x\+')(\.jpg)/
       end
       
       image = script.slice(s)
       image.sub!(/'\s\+\sx\s\+\s'/, page)
    
      #s = /(http:\/\/t\.fakku\.net)(.+?)('\+x\+')(\.jpg)/
      #image = @doc.css('script').text.slice(s)
      #image.sub!(/'\+x\+'/, page)

      [image, "Page - #{page}"]
    end

    def get_next_uri # STAR
      "#{::URI.join( @uri, 'read#page=')}#{@pages.length + 2}" 
    end
  end
end
