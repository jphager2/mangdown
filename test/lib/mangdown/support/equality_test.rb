require 'test_helper'

module Mangdown
  class EqualityTest < Minitest::Test
    def test_spaceship_operator
      name_struct = Struct.new(:name) do
        include Equality
      end

      assert_equal name_struct.new('Name'), name_struct.new('Name')
      refute_equal name_struct.new('Name'), name_struct.new('Other Name')
      assert name_struct.new('Name') < name_struct.new('Other Name')
      assert name_struct.new('Other Name') > name_struct.new('Name')

      assert_equal 0, name_struct.new('Name') <=> name_struct.new('Name')

      names = %w(a b c d e f).map { |name| name_struct.new(name) }

      assert_equal names, names.shuffle.sort
      assert_equal names.reverse, names.shuffle.sort.reverse
    end
  end
end

