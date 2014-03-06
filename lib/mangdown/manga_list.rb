module Mangdown
  class MangaList

    attr_reader :mangas

    def initialize(uri)
      @uri = uri
      @mangas = []

      get_mangas
    end

    def get_mangas
      doc = ::Mangdown::Tools.get_doc(@uri)
      root = ::Mangdown::Tools.get_root(@uri)

      # This should be put in a tool
      doc.css('ul.series_alpha li a').each do |a|
        hash = MDHash.new
        hash[:uri], hash[:name] = (root + a[:href]), a.text
        @mangas << hash
      end
    end
  end
end
