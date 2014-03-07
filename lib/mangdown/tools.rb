module Mangdown
  module Tools
    extend self
  
    def special?(klass)
      klasses = [Manga, Chapter, Page, MRChapter, MFChapter]

      if klasses.find(self.class)
        true
      else
        false
      end
    end

    def get_doc(uri)
      @doc = ::Nokogiri::HTML(open(uri))
    end

    def get_root(uri)
      @root = ::URI::join(uri, "/").to_s[0..-2] 
    end

    def to_s
      if special?(self.class)
        "<#{self.class}::#{self.object_id} : #{@name} : #{@uri}>"
      else
        super
      end
    end

    def eql?(other)
      if special?(self.class)
        (self.name == other.name) and (self.uri == other.uri)
      else
        super
      end
    end

    def ==(other)
      if special?(self.class)
        puts 'You may want to use eql?'
      end

      super
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
      start_dir = Dir.pwd
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
      Dir.chdir(start_dir)
    end

    def check_file_or_dir_name(name)

      # slice the last number in the file or directory name,
      # which will be either the page number or the chapter number
      num = name.slice(/(\d+)(\.jpg)*\Z/, 1)
    
      if num
        while num.length < 3
          num = '0' + num
        end
    
        name = name.sub(/(\d+)(\.jpg)*\Z/, num + '\2')
      end

      name
    end 

    def check_dir(dir)
      Dir.glob(dir + '/*').each do |file_name| 
        #do block on each file name, but skip .cbz files
        next if file_name.include?('.cbz')
        yield(file_name)
      end
    end 

    def validate_file_or_dir_names(dir)
      check_dir(dir) do |file_name|
        checked_name = check_file_or_dir_name(file_name)

        unless file_name == checked_name
          File.rename(file_name, checked_name)
        end
      end
    end
  end
end

