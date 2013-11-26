require_relative '../lib/mandown'

if ARGV.length == 3
  uri, name, pages = ARGV
  pages = pages.to_i
else
  puts 'Wrong number of arguments'
  exit
end

Dir.chdir('D:/Downloads/Manga/FK')

fk = Mandown::FKChapter.new(uri, name, pages)
fk.download
