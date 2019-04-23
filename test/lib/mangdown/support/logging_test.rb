# frozen_string_literal: true

require 'stringio'
require 'test_helper'

module Mangdown
  class LoggingTest < Minitest::Test
    class LoggingEnabled
      include Logging

      def log(message, level)
        logger.__send__(level, message)
      end

      def public_logger
        logger
      end

      def device
        logger.instance_variable_get(:@logdev).dev
      end
    end

    def setup
      @io = StringIO.new
      Mangdown.configure_logger(file: @io)

      @instance = LoggingEnabled.new
    end

    def teardown
      Mangdown.configure_logger(file: STDOUT)
    end

    # rubocop:disable Metrics/AbcSize
    def test_logger
      @instance.log('hello world', :debug)
      @instance.log('hello world', :fatal)

      assert_kind_of Logger, @instance.public_logger
      assert_equal 1, @io.string.scan(/DEBUG/).length
      assert_equal 1, @io.string.scan(/FATAL/).length
      assert_equal 2, @io.string.scan(/hello world/).length
    end
    # rubocop:enable Metrics/AbcSize

    def test_configure_logger
      assert_equal @io, @instance.device
    end
  end
end
