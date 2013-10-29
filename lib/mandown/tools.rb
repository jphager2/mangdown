module Mandown
	module Tools
		extend self
    def get_doc(uri)
      @doc = ::Nokogiri::HTML(open(uri))
    end
  
  	def get_root(uri)
      @root = ::URI::join(uri, "/").to_s[0..-2] 
	  end
	end
end

