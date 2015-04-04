require 'pathname'
require 'typhoeus'

module Mangdown
  module Tools
    extend self
  
		def get_doc(uri)
			@doc = ::Nokogiri::HTML(get(uri))
    end

    def get(uri)
      Typhoeus.get(uri).body
    end

    def get_root(uri)
      @root = ::URI::join(uri, "/").to_s[0..-2] 
    end

    def relative_or_absolute_path(*sub_paths)
      root = (sub_paths.first.to_s =~ /^\// ? sub_paths.shift : Dir.pwd)
      Pathname.new(root).join(*sub_paths)
    end

    def file_type(path)
      FileMagic.new.file(path.to_s).slice(/^\w+/).downcase
    end

    def hydra(objects)
      hydra = Typhoeus::Hydra.hydra

      requests = objects.map {|obj| 
        request = Typhoeus::Request.new(obj.uri)
        request.on_complete do |response|
          if response.success?
            yield(obj, response.body) if block_given?
          elsif response.timed_out?
            STDERR.puts "got a time out"
          elsif response.code == 0
            STDERR.puts "#{obj.uri}: #{response.return_message}"
          else
            STDERR.puts "HTTP request failed: #{response.code.to_s}"
          end
        end
        hydra.queue(request)
        request
      }

      hydra.run
      requests
    end
  end
end

