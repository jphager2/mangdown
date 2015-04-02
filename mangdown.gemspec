files = Dir.glob(Dir.pwd + '/**/*.rb')
#files.select! {|file| !( file =~ /\/db/)} 
files.collect! {|file| file.sub(Dir.pwd + '/', '')}
files.push('LICENSE', 'doc/help.txt')

Gem::Specification.new do |s|
  s.name        = 'mangdown'
  s.version     = '0.11.0'
	s.date        = "#{Time.now.strftime("%Y-%m-%d")}"
	s.homepage    = 'https://github.com/jphager2/mangdown'
  s.summary     = 'Downloads Manga'
  s.description = 'A gem to download Manga, (now using hydra)'
  s.authors     = ['jphager2']
  s.email       = 'jphager2@gmail.com'
  s.files       = files 
  s.license     = 'MIT'

  s.add_runtime_dependency 'activerecord'
  s.add_runtime_dependency 'pg',           '~> 0.15.1'

  s.add_runtime_dependency 'faraday',      '~> 0.9.0'
  s.add_runtime_dependency 'nokogiri',     '~> 1.6.0' 
  s.add_runtime_dependency 'rubyzip',      '~> 1.1.0'
  s.add_runtime_dependency 'progress_bar', '~> 1.0.3'
  s.add_runtime_dependency 'typhoeus',     '~> 0.7.1'

  s.add_development_dependency 'webmock'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'rake'
end
