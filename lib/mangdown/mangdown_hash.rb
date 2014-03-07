module Mangdown
  class MDHash < ::Hash
    def get_manga
      Manga.new(self)
    end
  end
end

