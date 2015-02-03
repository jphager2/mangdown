require_relative '../lib/mangdown'

require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'
require 'fileutils'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cpo_cassettes'
  c.hook_into :webmock
end

module SpecHelper
  extend self
  def stdout_for
    out, temp = StringIO.new, $stdout  
    $stdout = out
    yield
    out, $stdout = $stdout, temp
    out.rewind and out.read
  end
end
