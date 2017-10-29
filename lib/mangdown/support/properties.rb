# frozen_string_literal: true

module Mangdown
  # Provide hash-like access for object attributes
  module Properties
    def self.included(base)
      base.extend(ClassMethods)
    end

    def properties
      keys = self.class.properties
      values = keys.map { |name| self[name] }
      Hash[keys.zip(values)]
    end
    alias to_hash properties

    def fill_properties(other)
      other.each do |property, value|
        self[property] = value if self[property].to_s.empty?
      end
    end

    def [](key)
      instance_variable_get("@#{key}")
    end

    def []=(key, value)
      instance_variable_set("@#{key}", value)
    end

    def inspect
      properties.inspect
    end

    def to_s
      properties.to_s
    end

    # Macro for setting property names
    module ClassMethods
      def properties(*names)
        @properties ||= []
        return @properties if names.empty?

        @properties.concat(names).uniq!
        attr_accessor(*names)
      end
    end
  end
end
