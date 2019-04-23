# frozen_string_literal: true

require 'logger'

# Find, download and package manga from the web
module Mangdown
  # Configure and access the Mangdown logger
  module Logging
    private

    def logger
      Mangdown.logger
    end
  end

  class << self
    def logger
      @logger ||= configure_logger(file: STDOUT)
    end

    def configure_logger(options = {})
      logger_args = options.fetch(:logger_args) { [options[:file]] }
      @logger = Logger.new(*logger_args)
      @logger.level = options.fetch(:level, Logger::DEBUG)
      @logger
    end
  end
end
