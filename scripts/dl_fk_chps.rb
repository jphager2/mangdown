require_relative 'get_all_fk_page'


module Mandown
  fk_dir = 'd:/downloads/manga/FK'

  Dir.chdir(fk_dir)

  chps = ARGV[0].to_i
  chps = 1 unless (chps > 0 and chps < 100) 

  # puts "chps is: #{chps}"

  chapters_list = get_chapters(chps) 

  # puts chapters_list.length
  # puts chapters_list

  chapters_list.each do |ch|
    fk = FKChapter.new(ch[0], ch[1], ch[2])
    fk.download
  end

  CBZ.cbz_sub_dirs(fk_dir)
end
