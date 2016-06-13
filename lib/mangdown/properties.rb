module Mangdown
  module Properties

    def self.included(base)
      base.extend(ClassMethods)
    end

    def properties
      @_properties ||= {}
    end

    def [](key)
      properties[key]
    end
      
    def inspect
      properties.inspect
    end

    def to_s
      properties.to_s
    end

    module ClassMethods
      def properties(*names)
        names.each do |name|
          define_method(name) do
            properties[name]
          end

          define_method("#{name}=") do |other|
            properties[name] = other
          end
        end
      end
    end
  end
end
