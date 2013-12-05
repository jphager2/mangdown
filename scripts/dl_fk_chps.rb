require_relative 'get_all_fk_page'

module Mandown
  chps = ARGV[0].to_i
  chps = 1 unless (chps > 0 and chps < 100) 

  puts "chps is: #{chps}"

  chapters_list = []
  t = 1
  while chapters_list.length < chps
    chapters_list = get_chapters(t) 
    t += 1
  end

  puts chapters_list.length
end
