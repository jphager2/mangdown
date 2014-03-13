module Mangdown
  class MDHash < ::Hash
		def initialize(options)
			self[:uri]  = options[:uri]
			self[:name] = options[:name]
		end

    def get_manga
      Manga.new(self)
    end
  end
end

