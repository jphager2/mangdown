# frozen_string_literal: true

require 'forwardable'
require 'addressable/uri'
require 'mimemagic'
require 'nokogiri'
require 'yaml'
require 'zip'

require_relative 'mangdown/error'

require_relative 'mangdown/support/logging'
require_relative 'mangdown/support/equality'
require_relative 'mangdown/support/tools'
require_relative 'mangdown/support/cbz'
require_relative 'mangdown/page'
require_relative 'mangdown/chapter'
require_relative 'mangdown/manga'

require_relative 'mangdown/adapter/no_adapter_error'
require_relative 'mangdown/adapter/not_implemented_error'
require_relative 'mangdown/adapter/mangareader'
require_relative 'mangdown/adapter/manga_bat'

# Find, download and package manga from the web
module Mangdown
  class <<self
    include Logging
  end

  DOWNLOAD_DIR ||= Dir.home + '/manga'

  def self.register_adapter(name, adapter)
    adapters[name] = adapter
  end

  def self.adapters
    @adapters ||= {}
  end

  def self.manga(uri_or_instance)
    with_adapter(uri_or_instance, :manga) do |instance|
      Mangdown::Manga.new(instance)
    end
  end

  def self.chapter(uri_or_instance)
    with_adapter(uri_or_instance, :chapter) do |instance|
      Mangdown::Chapter.new(instance)
    end
  end

  def self.page(uri_or_instance)
    with_adapter(uri_or_instance, :page) do |instance|
      Mangdown::Page.new(instance)
    end
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def self.with_adapter(instance, instance_constructor)
    if instance.is_a?(String)
      adapter = adapter(instance)
      instance = adapter.public_send(instance_constructor, instance)
    else
      adapter = adapter(instance.url)
      klass = adapter.class.const_get(instance_constructor.to_s.capitalize)
      instance = klass.new(instance.attributes)
    end
    yield(instance)
  rescue Adapter::NoAdapterError
    raise
  rescue StandardError => error
    logger.error(debug_error(error, adapter, instance))
    raise Mangdown::Error, "Adapter failed: #{error.message}"
  end
  private_class_method :with_adapter
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def self.adapter(uri)
    adapter = adapters.values.find { |a| a.for?(uri) }

    raise Adapter::NoAdapterError, uri unless adapter

    adapter
  end
  private_class_method :adapter

  def self.debug_error(error, adapter, instance)
    {
      msg: 'Adapter method failed',
      adapter: adapter.class,
      instance: instance,
      error: error,
      error_msg: error.message,
      backtrace: error.backtrace
    }.to_s
  end
  private_class_method :debug_error

  register_adapter :mangareader, Mangdown::Mangareader.new
  register_adapter :manga_bat, Mangdown::MangaBat.new
end
