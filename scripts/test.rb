
require_relative '../lib/mandown'

module Mandown
  uri, name, option = ARGV
  option = option.to_i

  puts "uri is #{uri}, a #{name.class}"
  puts "name is #{name}, a #{name.class}"
  puts "option is #{option}, a #{option.class}"

  $m = Manga.new(uri, name)
end

puts $m


