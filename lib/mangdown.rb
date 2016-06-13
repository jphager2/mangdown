require 'uri'
require 'nokogiri'
require 'yaml'
require 'zip'
require 'filemagic'

require_relative 'mangdown/equality'
require_relative 'mangdown/tools'
require_relative 'mangdown/uri'
require_relative 'mangdown/page'
require_relative 'mangdown/chapter'
require_relative 'mangdown/manga'
require_relative 'mangdown/manga_list.rb'
require_relative 'mangdown/cbz'
require_relative 'mangdown/md_hash'

require_relative 'mangdown/adapter'
require_relative 'mangdown/adapter/no_adapter_error'
require_relative 'mangdown/adapter/mangareader.rb'
require_relative 'mangdown/adapter/mangapanda.rb'
require_relative 'mangdown/adapter/mangafox.rb'
require_relative 'mangdown/adapter/mangahere.rb'
require_relative 'mangdown/adapter/wiemanga.rb'

module Mangdown
  ADAPTERS = {}

  DOWNLOAD_DIR ||= Dir.home + '/manga'

  def self.register_adapter(name, adapter)
    ADAPTERS[name] = adapter
  end

  def self.adapter(name)
    ADAPTERS[name]
  end

  def self.adapter!(uri, site = nil, doc = nil, name = nil)
    adapter_name = (uri || site).to_s
    klass = ADAPTERS.values.find { |adapter| adapter.for?(adapter_name) }

    if klass
      klass.new(uri, doc, name)
    else
      raise Adapter::NoAdapterError.new(adapter_name)
    end
  end
end

Mangdown.register_adapter(:mangareader, Mangdown::Mangareader)
Mangdown.register_adapter(:mangapanda, Mangdown::Mangapanda)
Mangdown.register_adapter(:mangafox, Mangdown::Mangafox)
Mangdown.register_adapter(:mangahere, Mangdown::Mangahere)
Mangdown.register_adapter(:wiemanga, Mangdown::Wiemanga)
