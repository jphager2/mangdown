require 'pathname'
require 'typhoeus'

module Mangdown
  module Tools
    class << self
  
      def get_doc(uri)
        data = get(uri)
        @doc = ::Nokogiri::HTML(data)
      end

      def get(uri)
        Typhoeus.get(uri).body
      end

      def get_root(uri)
        uri = ::URI.parse(uri)
        @root = "#{uri.scheme}://#{uri.host}"
      end

      def relative_or_absolute_path(*sub_paths)
        Pathname.new(Dir.pwd).join(*sub_paths)
      end

      def valid_path_name(name)
        name.to_s.sub(/(\d+)(\.\w+)*\Z/) do
          digits, ext = Regexp.last_match[1..2]
          digits.to_i.to_s.rjust(5, "0") + ext.to_s
        end
      end 

      def image_extension(path)
        path = path.to_s

        return unless File.exist?(path)

        mime = FileMagic.new(:mime).file(path)
        mime_to_extension(mime)
      end

      def hydra_streaming(objects)
        hydra = Typhoeus::Hydra.hydra

        requests = objects.map { |obj| 
          next unless yield(:before, obj)

          request = Typhoeus::Request.new(obj.uri)
          request.on_headers do |response|
            status = response.success? ? :succeeded : :failed
            yield(status, obj)
          end
          request.on_body do |chunk|
            yield(:body, obj, chunk) 
          end
          request.on_complete do |response|
            yield(:complete, obj)
          end

          hydra.queue(request)
          request
        }.compact

        hydra.run
        requests
      end

      private

      def mime_to_extension(mime)
        return unless mime.start_with?('image')

        mime.split(';').first.split('/').last
      end
    end
  end
end
