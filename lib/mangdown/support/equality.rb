module Mangdown 
  module Equality
    include Comparable

    def <=>(other)
      self.name <=> other.name
    end
  end
end
