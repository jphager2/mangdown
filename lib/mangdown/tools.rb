module Mangdown
  module Tools
    extend self
  
		def return_to_start_dir 
			start = Dir.pwd
			yield
			Dir.chdir(start)
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
        timeout(120) do
          yield 
        end
      rescue
        if tries >= 0
          puts "Tries left: #{tries}"
          no_time_out(tries, &block)
        else
          return :timed_out
        end
      end
    end

    def slow_get_chapters(manga, bgn, nd)
      @@file_name = File.expand_path("#{manga.name}_temp.yml")

      # get Manga object from file if it exists
      if File.exist?(@@file_name)
        manga_from_file = YAML.load(File.open(@@file_name, 'r').read) 
      end

      if manga_from_file and (manga_from_file.chapters.length > 0)
        frst = (manga.chapters_list[bgn][:name] == 
               manga_from_file.chapters.first.name) 
        lst = (manga.chapters_list[nd][:name] == 
               manga_from_file.chapters.last.name)
        # check if this is the right temp file
        manga = manga_from_file if (frst and lst)
      else
        manga.chapters_list[bgn..nd].each_index do |i|
          no_time_out {manga.get_chapter(i + bgn)}
        end
      end

      File.open(@@file_name, 'w') {|f| f.write(manga.to_yaml)}

      manga
    end

    def slow_dl_chapters(manga)
			return_to_start_dir do 
				Dir.mkdir(manga.name) unless Dir.exist?(manga.name)
				Dir.chdir(manga.name)

				manga_start_dir = Dir.pwd
				manga.chapters.each do |chap|
					no_time_out do 
						Dir.chdir(manga_start_dir)
						chap.download
					end
				end

				File.delete(@@file_name)
			end
    end
  end
end

