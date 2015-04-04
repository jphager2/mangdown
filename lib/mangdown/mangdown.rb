module Mangdown 
  ADAPTERS = []

  module Equality
    def eql?(other)
      (self.name == other.name) && (self.uri == other.uri)
    end

    def ==(other)
      # puts "You may want to use :eql?"
      super
    end

    # space ship operator for sorting
    def <=>(other)
      self.name <=> other.name
    end
  end
end
