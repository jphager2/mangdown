require 'uri'
require 'nokogiri'
require 'yaml'
require 'zip'
require 'filemagic'

module Mangdown
  ADAPTERS = []

  DOWNLOAD_DIR ||= Dir.home + '/manga'
end

require_relative 'mangdown/adapter'
adapters = "#{File.expand_path('../mangdown/adapter', __FILE__)}/*.rb"
Dir[adapters].each do |f|
  require_relative f 
end

require_relative 'mangdown/equality'
require_relative 'mangdown/tools'
require_relative 'mangdown/properties'
require_relative 'mangdown/uri'
require_relative 'mangdown/page'
require_relative 'mangdown/chapter'
require_relative 'mangdown/manga'
require_relative 'mangdown/manga_list.rb'
require_relative 'mangdown/cbz'
require_relative 'mangdown/commands'
require_relative 'mangdown/md_hash'


