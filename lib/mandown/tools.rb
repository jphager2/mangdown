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
	end
end

