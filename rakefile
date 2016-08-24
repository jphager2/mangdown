require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/lib/**/*_test.rb"
  t.verbose = true
end

task default: [:test]
