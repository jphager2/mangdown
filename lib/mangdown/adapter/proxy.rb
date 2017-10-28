module Mangdown
  module Adapter
    # Wraps Adapters to provide error reporting
    class Proxy
      include Logging

      attr_reader :adapter

      def initialize(adapter)
        @adapter = adapter
      end

      private

      def method_missing(method, *args, &block)
        return super unless @adapter.respond_to?(method)

        adapter.public_send(method, *args, &block)
      rescue => e
        logger.error({
          msg: 'Adapter method failed',
          adapter: adapter.class,
          uri: adapter.uri,
          doc: adapter.doc.to_s,
          method: method,
          error: e,
          error_msg: e.message,
          backtrace: e.backtrace
        }.to_s)
        raise Mangdown::Error, "Adapter failed: #{e.message}"
      end
    end
  end
end
