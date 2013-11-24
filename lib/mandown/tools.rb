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

		def slow_get_chapters(m, bgn, nd)
			@@file_name = File.expand_path("#{m.name}_temp.yml")

			exists = File.exist?(@@file_name)
			m_from_file = YAML.load(File.open(@@file_name, 'r').read) if exists

			if m_from_file and (m_from_file.chapters.length > 0)
				frst = (m.chapters_list[bgn][1] == m_from_file.chapters.first.name) 
				lst = (m.chapters_list[nd][1] == m_from_file.chapters.last.name)

				m = m_from_file if (frst and lst)
			else
				m.chapters_list[bgn..nd].each_index do |i|
					no_time_out {m.get_chapter(i + bgn)}
				end
			end

			File.open(@@file_name, 'w') {|f| f.write(m.to_yaml)}
			m
		end

		def slow_dl_chapters(m)
			Dir.mkdir(m.name) unless Dir.exist?(m.name)
			Dir.chdir(m.name)

			m.chapters.each do |chap|
				puts "DL - #{chap.name}.."
				no_time_out {chap.download}
			end

			File.delete(@@file_name)
		end
	end
end

