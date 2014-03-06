module Mangdown
  class MangaList

    attr_reader :mangas

    def initialize(*uri)
      @uri = uri
      @mangas = []

      @uri.each {|uri| get_mangas(uri)}
    end

    def get_mangas(uri)
      doc = ::Mangdown::Tools.get_doc(uri)
      root = ::Mangdown::Tools.get_root(uri)

      
      # This should be put in a tool
      doc.css(css_klass(root)).each do |a|
        hash = MDHash.new
        hash[:uri], hash[:name] = (root + a[:href]), a.text
        @mangas << hash
      end
    end

    def css_klass(site)
      case site
      when /mangareader/
        'ul.series_alpha li a'
      when /mangafox/
        'div.manga_list li a'
      else
        nil
      end
    end
  end
end
