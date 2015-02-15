module Mangdown
	class Properties

		attr_reader :info

		def initialize(site)
			@info = Hash.new

      case site 
      when /mangareader/
				mangareader
      when /mangapanda/ 
        #mangapanda is a mirror of mangareader
        #that being said, I really don't think this works
        #especially with @info[:root]
        mangareader
      when /mangafox/
				mangafox
      else
        nil
      end
		end

		def mangareader
			@info[:manga_list_css_klass] = 'ul.series_alpha li a'
			@info[:manga_css_klass]      = 'div#chapterlist td a'
			@info[:chapter_klass]        = MRChapter
			@info[:root]                 = 'http://www.mangareader.net'
			@info[:manga_link_prefix]    = @info[:root] 
			@info[:reverse]              = false
		end

		def mangafox
			@info[:manga_list_css_klass] = 'div.manga_list li a'
			@info[:manga_css_klass]      = 'a.tips'
			@info[:chapter_klass]        = MFChapter
			@info[:root]                 = 'http://mangafox.me'
			@info[:manga_link_prefix]    = ''
			@info[:reverse]              = true
		end

    def empty?
      @info.empty?
    end

		private
			def method_missing(method, *args, &block)
        # this should probably be if @info.has_key?(method)
        # or more consisely @info.fetch(method) { super }
				return @info[method] unless @info[method].nil?
				super
			end
	end
end
