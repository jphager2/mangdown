# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require 'warning'

Gem.path.each do |path|
  Warning.ignore(//, path)
end
Warning.ignore(/method redefined/)
Warning.ignore(/previous definition/)

require 'mangdown'

require_relative 'support/test_adapter'

# rubocop:disable Style/TrivialAccessors
def test_adapter
  @test_adapter
end
# rubocop:enable Style/TrivialAccessors

def register_test_adapter
  @test_adapter = TestAdapter.new

  Mangdown.register_adapter(:test, test_adapter)
end

# rubocop:disable Metrics/MethodLength
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
      # rubocop:disable Lint/DuplicateMethods
      alias_method :all, :old_all
      alias_method :one, :old_one
      # rubocop:enable Lint/DuplicateMethods
    end
  end
end
# rubocop:enable Metrics/MethodLength
