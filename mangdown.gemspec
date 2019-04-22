# frozen_string_literal: true

require_relative 'lib/mangdown/version'

files = Dir.glob(Dir.pwd + '/**/*.rb')
files.collect! { |file| file.sub(Dir.pwd + '/', '') }
files.push('LICENSE', 'README.md')

Gem::Specification.new do |s|
  s.name        = 'mangdown'
  s.version     = Mangdown::VERSION
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.homepage    = 'https://github.com/jphager2/mangdown'
  s.summary     = 'Download Manga'
  s.description = 'Download Manga'
  s.authors     = ['jphager2']
  s.email       = 'jphager2@gmail.com'
  s.files       = files
  s.license     = 'MIT'

  s.add_runtime_dependency 'addressable'
  s.add_runtime_dependency 'mimemagic'
  s.add_runtime_dependency 'nokogiri', '~> 1.8'
  s.add_runtime_dependency 'rubyzip',      '~> 1.1'
  s.add_runtime_dependency 'scrapework'
  s.add_runtime_dependency 'sequel'
  s.add_runtime_dependency 'sqlite3'
  s.add_runtime_dependency 'typhoeus',     '~> 1.3'

  s.add_development_dependency 'minitest', '~> 5.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'webmock'
end
