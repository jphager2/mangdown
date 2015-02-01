require_relative '../lib/mangdown'

require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'
require 'fileutils'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cpo_cassettes'
  c.hook_into :webmock
end
