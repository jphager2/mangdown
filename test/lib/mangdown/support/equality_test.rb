# frozen_string_literal: true

require 'test_helper'

module Mangdown
  class EqualityTest < Minitest::Test
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def test_spaceship_operator
      name_struct = Struct.new(:name) do
        include Equality
      end

      assert_equal name_struct.new('Name'), name_struct.new('Name')
      refute_equal name_struct.new('Name'), name_struct.new('Other Name')
      assert name_struct.new('Name') < name_struct.new('Other Name')
      assert name_struct.new('Other Name') > name_struct.new('Name')

      # rubocop:disable Lint/UselessComparison
      assert_equal 0, name_struct.new('Name') <=> name_struct.new('Name')
      # rubocop:enable Lint/UselessComparison

      names = %w[a b c d e f].map { |name| name_struct.new(name) }

      assert_equal names, names.shuffle.sort
      assert_equal names.reverse, names.shuffle.sort.reverse
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize
  end
end
