# frozen_string_literal: true

module Mangdown
  module Adapter
    # No matching Mangdown adpter found
    class NoAdapterError < Mangdown::Error
      def initialize(site)
        super("Bad Site: No Adapter Specified for Site: #{site.inspect}")
      end
    end
  end
end
