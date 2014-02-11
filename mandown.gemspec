files = Dir.glob(Dir.pwd + '/lib/*/*.rb')

Gem::Specification.new do |s|
  s.name        = 'mandown'
  s.version     = '0.6.0'
  s.date        = '2013-02-14'
  s.summary     = 'Downloads Manga'
  s.description = 'A gem to download Manga'
  s.authors     = ['jphager2']
  s.email       = 'jphager2@gmail.com'
  s.files       = files 
  s.license     = 'MIT'
end
