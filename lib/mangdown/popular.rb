module Mangdown
  class PopularManga

    include Equality
    include Enumerable
    attr_reader :uri, :mangas, :name

    def initialize(uri, num_mangas = 30, name = "My Pop Manga")
      @uri        = uri 
      @num_mangas = num_mangas
      @name       = name
      @mangas     = []

      get_mangas_list
    end

    # iterate over mangas (for enumerable)
    def each
      @mangas.each {|manga| yield(manga) if block_given?}
    end

    private
      # I guess this is only for manga reader. need to use properties
      # and or sub classes for other sites
      def get_mangas_list
        (@num_mangas / 30.0).ceil.times do |time|
          @mangas += get_pop_page_manga(time) 
        end
      end

      def get_pop_page_manga(time)
        root = Tools.get_root(uri)

        num = 30 * (time)
        page = root + '/popular/' + num.to_s
        doc = Tools.get_doc(page)

        last = (@num_mangas > 30) ? 30 : @num_mangas
        @num_mangas -= 30

        get_manga_on_page(doc, root)[0..(last - 1)]
      end

      def get_manga_on_page(doc, root)
        doc.css('h3 a').map do |a| 
          MDHash.new({
            uri: (root + a['href']),
            name: a.text
          })
        end
      end
  end
end
