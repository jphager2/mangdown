require 'test_helper'

module Mangdown
  class PropertiesTest < Minitest::Test
    class SomeObject
      include Properties

      properties :property_a, :property_b
    end

    def setup
      @object = SomeObject.new
    end

    def test_properties
      assert_equal({ property_a: nil, property_b: nil }, @object.properties)
    end

    def test_getters_and_setters
      @object.property_a = 'Property A'

      assert_equal 'Property A', @object.property_a

      assert_equal 'Property A', @object.properties[:property_a]
    end

    def test_delegates_methods_to_properties
      assert_equal @object.properties.inspect, @object.inspect
      assert_equal @object.properties.to_s, @object.to_s
    end

    def test_hash_access
      @object.property_a = 'Property A'

      assert_equal 'Property A', @object[:property_a]
    end

    def test_to_hash_conversion
      assert_equal @object.properties, @object.to_hash
    end

    def test_assign_property_value_as_instance_variable
      @object.instance_variable_set(:@property_b, 'Property B')

      assert_equal 'Property B', @object[:property_b]
    end

    def test_fill_properties
      @object.property_a = 'Property A'

      @object.fill_properties(
        property_a: 'Other Value', property_b: 'Property B'
      )

      assert_equal 'Property A', @object.property_a
      assert_equal 'Property B', @object.property_b
    end
  end
end
