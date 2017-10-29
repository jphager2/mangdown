# frozen_string_literal: true

module Mangdown
  # Mangdown object equality
  module Equality
    include Comparable

    def <=>(other)
      name <=> other.name
    end
  end
end
