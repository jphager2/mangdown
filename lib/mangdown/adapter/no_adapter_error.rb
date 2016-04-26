module Mangdown
  module Adapter
    class NoAdapterError < StandardError
      def initialize(site)
        super("Bad Site: No Adapter Specified for Site: #{site.inspect}")
      end
    end
  end
end
