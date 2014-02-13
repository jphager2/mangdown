module Mandown
  class MDHash < ::Hash
    def get_manga
      Manga.new(self[:uri], self[:name])
    end
  end
end

