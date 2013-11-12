require_relative '../lib/mandown'
require 'timeout'

Dir.chdir('D:/downloads/manga')


module Mandown
  def slow_get_chapters(m, bgn, nd)
    @@file_name = "#{m.name}_temp.yml"

    if File.exist?(@@file_name) 
      m_from_file = YAML.load(File.open(@@file_name, 'r').read)

      frst = (m.chapters_list[bgn][1] == m_from_file.chapters.first.name) 
      lst = (m.chapters_list[nd][1] == m_from_file.chapters.last.name)

      m = m_from_file if (frst and lst) 
    else
      m.chapters_list[bgn..nd].each_index do |i|

      tries = 3
      begin
        timeout(120) do
          m.get_chapter(i + bgn)
        end
        rescue
          if tries > 0
          tries -= 1
            puts "Tries left: #{tries}"
            redo
          else
            break
          end
        end
      end
    end

    File.open(@@file_name, 'w') {|f| f.write(m.to_yaml)}
    m
  end

  def slow_dl_chapters(m)
    Dir.mkdir(m.name) unless Dir.exist?(m.name)
    Dir.chdir(m.name)

    m.chapters.each do |chap|
      timeout(120) do
	puts "DL - #{chap.name}.."
        chap.download
      end
    end
  end

end

include Mandown





if __FILE__ == $0
  unless ARGV.length >= 2
    puts 'Wrong number of arguments'
    exit    
  end

  uri, name = ARGV

  m = Manga.new(uri, name)

  bgn = ARGV[2] ? ARGV[2].to_i - 1 : 0
  nd = ARGV[3] ? ARGV[3].to_i - 1 : m.chapters_list.length
  
  m = slow_get_chapters(m, bgn, nd)
  slow_dl_chapters(m)
else
  puts "Mandown module included."
  puts "Ready.."
end
