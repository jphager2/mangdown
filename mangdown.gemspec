require_relative 'lib/mangdown/version'

files = Dir.glob(Dir.pwd + '/**/*.rb')
files.collect! {|file| file.sub(Dir.pwd + '/', '')}
files.push('LICENSE', 'README.md')

Gem::Specification.new do |s|
  s.name        = 'mangdown'
  s.version     = Mangdown::VERSION
	s.date        = "#{Time.now.strftime("%Y-%m-%d")}"
	s.homepage    = 'https://github.com/jphager2/mangdown'
  s.summary     = 'Downloads Manga'
  s.description = 'A gem to download Manga'
  s.authors     = ['jphager2']
  s.email       = 'jphager2@gmail.com'
  s.files       = files 
  s.license     = 'MIT'

  s.add_runtime_dependency 'typhoeus',     '~> 0.7.1'
  s.add_runtime_dependency 'nokogiri',     '~> 1.6.0' 
  s.add_runtime_dependency 'rubyzip',      '~> 1.1.0'
  s.add_runtime_dependency 'progress_bar', '~> 1.0.3'
  s.add_runtime_dependency 'ruby-filemagic'

  s.add_development_dependency 'webmock'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest', '~> 5.0'
end
