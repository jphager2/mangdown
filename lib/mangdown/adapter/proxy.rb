# frozen_string_literal: true

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
      rescue StandardError => error
        logger.error(debug_error(method, error))
        raise Mangdown::Error, "Adapter failed: #{error.message}"
      end

      def respond_to_missing?(method, include_all)
        @adapter.respond_to?(method, include_all)
      end

      def debug_error(method, error)
        {
          msg: 'Adapter method failed',
          adapter: adapter.class,
          uri: adapter.uri,
          doc: adapter.doc.to_s,
          method: method,
          error: error,
          error_msg: error.message,
          backtrace: error.backtrace
        }.to_s
      end
    end
  end
end
