# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'

require 'mangdown'

require_relative 'support/test_adapter'

def test_adapter
  @test_adapter
end

def register_test_adapter
  @test_adapter = TestAdapter.new

  Mangdown.register_adapter(:test, test_adapter)
end

def with_stubbed_cbz
  Mangdown::CBZ.class_eval do
    class << self
      alias old_all all
      alias old_one one

      def all(path)
        ['cbz_called', path]
      end

      def one(path)
        ['cbz_called', path]
      end
    end
  end
  yield
ensure
  Mangdown::CBZ.class_eval do
    class << self
      alias all old_all
      alias one old_one
    end
  end
end
