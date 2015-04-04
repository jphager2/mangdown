require 'uri'
require 'open-uri'
require 'nokogiri'
require 'yaml'
require 'timeout'
require 'zip'

require_relative 'mangdown/mangdown'

require_relative 'mangdown/adapter'
adapters = "#{File.expand_path('../mangdown/adapter', __FILE__)}/*.rb"
Dir[adapters].each do |f|
  require_relative f 
end

require_relative 'mangdown/tools'
require_relative 'mangdown/properties'
require_relative 'mangdown/uri'
require_relative 'mangdown/page'
require_relative 'mangdown/chapter'
require_relative 'mangdown/manga'
require_relative 'mangdown/popular'
require_relative 'mangdown/manga_list.rb'
require_relative 'mangdown/cbz'
require_relative 'mangdown/commands'
require_relative 'mangdown/mangdown_hash'

unless $0 == __FILE__
  puts '*** Use "M.help" for commands ***'
end
