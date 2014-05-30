require 'timeout'

module Mangdown
  module Tools
    extend self
  
		def return_to_start_dir 
			start = Dir.pwd
			yield
			Dir.chdir(start)
    rescue Exception => error
      Dir.chdir(start)
      raise error
		end

    def get_doc(uri)
			@doc = ::Nokogiri::HTML(open(uri))
    end

    def get_root(uri)
      @root = ::URI::join(uri, "/").to_s[0..-2] 
    end
    
    def no_time_out(tries = 3, &block)
      tries -= 1
      begin 
        timeout(120) { yield } 
      rescue Timeout::Error
        tries >= 0 ? no_time_out(tries, &block) : :timed_out
      end
    end

    class Downloader
      include Tools

      def initialize(manga, first, last)
        @tempfile = File.expand_path("#{manga.name}_temp.yml")

        chapters = slow_get_chapters(manga, first, last)
        slow_dl_chapters(chapters)
      end

      def slow_get_chapters(manga, bgn, nd)
        # get Manga object from file if it exists
        if File.exist?(@tempfile)
          manga_from_file = YAML
            .load(File.open(@tempfile, 'r').read) 
        end

        # if the manga is from tempfile and the manga has chapters
        # then check if it has the right chapters 
        if manga_from_file and (manga_from_file.chapters.length > 0)
          frst = (manga.chapters_list[bgn][:name] == 
                 manga_from_file.chapters.first.name) 
          lst = (manga.chapters_list[nd][:name] == 
                 manga_from_file.chapters.last.name)
          manga = manga_from_file if (frst and lst)
        else
          threads = []
          manga.chapters_list[bgn..nd].each_index do |index|
            threads << Thread.new(index) do |i|
              no_time_out {manga.get_chapter(i + bgn)}
            end
          end
          threads.each {|thread| thread.join}
        end

        File.open(@tempfile, 'w') {|f| f.write(manga.to_yaml)}

        manga
      end

      def slow_dl_chapters(manga)
        return_to_start_dir do 
          Dir.mkdir(manga.name) unless Dir.exist?(manga.name)
          Dir.chdir(manga.name)

          manga.chapters.each do |chap|
            no_time_out do 
              return_to_start_dir {chap.download}
            end
          end

          File.delete(@tempfile)
        end
      end
    end
  end
end

