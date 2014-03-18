module Mangdown
	class Properties

		def initialize(site)
			@info = Hash.new

      case site 
      when /mangareader/
				mangareader
      when /mangafox/
				mangafox
      else
        nil
      end
		end

		def mangareader
			@info[:manga_css_klass] = 'div#chapterlist td a'
			@info[:chapter_klass] = MRChapter
			@info[:root] = 'http://www.mangareader.net'
		end

		def mangafox
			@info[:manga_css_klass] = 'a.tips'
			@info[:chapter_klass] = MFChapter
			@info[:root] = 'http://mangafox.me'
		end

		def method_missing(method, *args, &block)
			return @info[method] if @info[method]
			super
		end
	end
end
