require 'uri'
require 'open-uri'
require 'nokogiri'
require 'yaml'
require 'timeout'
require 'zip'

require_relative 'mandown/tools'
require_relative 'mandown/page'
require_relative 'mandown/chapter'
require_relative 'mandown/manga'
require_relative 'mandown/popular'
require_relative 'mandown/cbz'
require_relative 'mandown/commands'
require_relative 'mandown/mandown_hash'

unless $0 == __FILE__
  puts '*** Use "M.help" for commands ***'
end
