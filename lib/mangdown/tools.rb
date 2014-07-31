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
      timeout(30) { yield } 
    rescue Timeout::Error
      retry if (tries -= 1) >= 0  
    end
  end
end

