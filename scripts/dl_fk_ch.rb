require_relative '../lib/mangdown'

if ARGV.length == 3
  uri, name, pages = ARGV
  pages = pages.to_i
else
  puts 'Wrong number of arguments'
  exit
end

Dir.chdir('D:/Downloads/Manga/FK')

fk = Mangdown::FKChapter.new(uri, name, pages)
fk.download
