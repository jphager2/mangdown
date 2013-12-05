module Mandown
  module Tools
    extend self
  
    def get_doc(uri)
      @doc = ::Nokogiri::HTML(open(uri))
    end

    def get_root(uri)
      @root = ::URI::join(uri, "/").to_s[0..-2] 
    end

    def to_s
      "<#{self.class}::#{self.object_id} : #{@name} : #{@uri}>"
    end

    def eql?(other)
      (@name == other.name) and (@uri == other.uri)
    end

    def ==(other)
      puts 'You may want to use :eql?'
      super
    end

    def no_time_out(tries = 3)
      begin 
        timeout(120) do
          yield 
	end
      rescue
	if tries > 0
          tries -= 1
	  puts "Tries left: #{tries}"
	  no_time_out(tries)
	else
	  return
	end
      end
    end

    def slow_get_chapters(manga, bgn, nd)
      @@file_name = File.expand_path("#{manga.name}_temp.yml")

      exists = File.exist?(@@file_name)
      manga_from_file = YAML.load(File.open(@@file_name, 'r').read) if exists

      if manga_from_file and (manga_from_file.chapters.length > 0)
	frst = (manga.chapters_list[bgn][1] ==
				manga_from_file.chapters.first.name) 
	lst = (manga.chapters_list[nd][1] == manga_from_file.chapters.last.name)
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
      start_dir = Dir.pwd
      Dir.mkdir(manga.name) unless Dir.exist?(manga.name)
      Dir.chdir(manga.name)

      manga.chapters.each do |chap|
        # puts "DL - #{chap.name}.."
        no_time_out {chap.download}
      end

      File.delete(@@file_name)
      Dir.chdir(start_dir)
    end

    def check_file_or_dir_name(name)
      num = name.slice(/(\d+)(\.jpg)*\Z/, 1)
    
      if num
        while num.length < 3
          num = '0' + num
        end
    
        name.sub(/(\d+)(\.jpg)*\Z/, num + '\2')
      end

      name
    end 

    def check_dir(dir)
      Dir.glob(dir + '/*').each do |d| 
        next if d.include?('.cbz')
        yield(d)
      end
    end 

    def validate_file_or_dir_names(dir)
      check_dir(dir) do |e|
        f = check_file_or_dir_name(e)

        unless f == e
          File.rename(e, f)
        end
      end
    end
  end
end

