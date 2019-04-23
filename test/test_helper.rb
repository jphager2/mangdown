# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'

require 'mangdown'

require_relative 'support/test_adapter'

attr_reader :test_adapter

def register_test_adapter
  @test_adapter = TestAdapter.new

  Mangdown.register_adapter(:test, test_adapter)
end

def with_stubbed_cbz
  Mangdown::CBZ.class_eval do
    class << self
      alias_method :old_all, :all
      alias_method :old_one, :one

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
      alias_method :all, :old_all
      alias_method :one, :old_one
    end
  end
end
