# frozen_string_literal: true

require 'addressable/uri'
require 'nokogiri'
require 'yaml'
require 'zip'
require 'filemagic'

require_relative 'mangdown/error'

require_relative 'mangdown/support/logging'
require_relative 'mangdown/support/equality'
require_relative 'mangdown/support/properties'
require_relative 'mangdown/support/tools'
require_relative 'mangdown/support/cbz'
require_relative 'mangdown/page'
require_relative 'mangdown/chapter'
require_relative 'mangdown/manga'
require_relative 'mangdown/manga_list.rb'
require_relative 'mangdown/md_hash'

require_relative 'mangdown/adapter'
require_relative 'mangdown/adapter/proxy'
require_relative 'mangdown/adapter/no_adapter_error'
require_relative 'mangdown/adapter/not_implemented_error'
require_relative 'mangdown/adapter/mangareader.rb'

# Find, download and package manga from the web
module Mangdown
  DOWNLOAD_DIR ||= Dir.home + '/manga'

  module_function

  def register_adapter(name, adapter)
    adapters[name] = adapter
  end

  def adapter(name)
    adapters[name]
  end

  def adapter!(uri, site = nil, doc = nil, name = nil)
    adapter_name = (uri || site).to_s
    klass = adapters.values.find { |adapter| adapter.for?(adapter_name) }

    raise Adapter::NoAdapterError, adapter_name unless klass

    Adapter::Proxy.new(klass.new(uri, doc, name))
  end

  def adapters
    @adapters ||= {}
  end
end

Mangdown.register_adapter(:mangareader, Mangdown::Mangareader)
