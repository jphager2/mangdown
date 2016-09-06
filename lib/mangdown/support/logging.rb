require 'logger'

module Mangdown
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
