module Mangdown 
  module Equality
    def eql?(other)
      (self.name == other.name) && (self.uri == other.uri)
    end

    def ==(other)
      puts "You may want to use :eql?"
      super
    end
  end
end
