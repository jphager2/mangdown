# frozen_string_literal: true

require 'pathname'
require 'typhoeus'

Typhoeus::Config.verbose = $DEBUG

module Mangdown
  # Common helpers
  module Tools
    class << self
      def get_doc(uri)
        data = get(uri)
        @doc = Nokogiri::HTML(data)
      end

      def get(uri)
        Typhoeus.get(uri).body
      end

      def get_root(uri)
        uri = Addressable::URI.parse(uri)
        @root = "#{uri.scheme}://#{uri.host}"
      end

      def relative_or_absolute_path(*sub_paths)
        Pathname.new(Dir.pwd).join(*sub_paths)
      end

      def valid_path_name(name)
        name.to_s.sub(/(\d+)(\.\w+)*\Z/) do
          digits, ext = Regexp.last_match[1..2]
          digits.to_i.to_s.rjust(5, '0') + ext.to_s
        end
      end

      def image_extension(path)
        path = path.to_s

        return unless File.exist?(path)

        mime = MimeMagic.by_magic(File.open(path, 'r'))
        mime_to_extension(mime)
      end

      def hydra_streaming(objects, hydra_opts = {})
        hydra = Typhoeus::Hydra.new(hydra_opts)

        requests = objects.map do |obj|
          next unless yield(:before, obj)

          request = typhoeus(obj.uri)
          request.on_headers do |response|
            status = response.success? ? :succeeded : :failed
            yield(status, obj)
          end
          request.on_body do |chunk|
            yield(:body, obj, chunk)
          end
          request.on_complete do |_response|
            yield(:complete, obj)
          end

          hydra.queue(request)
          request
        end.compact

        hydra.run
        requests
      end

      def typhoeus(uri)
        Typhoeus::Request.new(uri, typhoeus_options)
      end

      def typhoeus_options
        {
          headers: {
            'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.62 Safari/537.36'
          }
        }
      end

      private

      def mime_to_extension(mime)
        return unless mime.mediatype == 'image'

        mime.subtype
      end
    end
  end
end
