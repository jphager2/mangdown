require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/mangdown'

class TestAdapter < Mangdown::Adapter::Base
  def self.for?(url_or_site)
    url_or_site == "test"
  end
end

Mangdown.register_adapter(:test, TestAdapter)
