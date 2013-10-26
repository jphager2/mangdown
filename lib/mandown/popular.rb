module Mandown
  class PopularManga
		attr_reader :uri, :mangas_list

		def initialize(uri, num_mangas)
			@uri = uri
			@mangas_list = []
		end
	end
end
