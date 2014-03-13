files = Dir.glob(Dir.pwd + '/**/*.rb')
files.collect! {|file| file.sub(Dir.pwd + '/', '')}
files.push('LICENSE', 'doc/help.txt')

Gem::Specification.new do |s|
  s.name        = 'mangdown'
  s.version     = '0.8.4'
	s.date        = "#{Time.now.strftime("%Y-%m-%d")}"
	s.homepage    = 'https://github.com/jphager2/mangdown'
  s.summary     = 'Downloads Manga'
  s.description = 'A gem to download Manga'
  s.authors     = ['jphager2']
  s.email       = 'jphager2@gmail.com'
  s.files       = files 
  s.license     = 'MIT'
end
