module Mangdown
	class Properties

		def initialize(uri, site = nil, doc = nil, name = nil)
      adapter_class = adapter_for_site(uri || site)

      if adapter_class
        @adapter = adapter_class.new(uri, doc, name)
      else
        raise Adapter::NoAdapterError.new(uri || site)
      end
		end

    private
    def adapter_for_site(site)
      ADAPTERS.find { |adapter| site.to_s[adapter.site] }
    end

    def method_missing(method, *args, &block)
      if @adapter.respond_to?(method)
        @adapter.__send__(method, *args, &block)
      else
        super
      end
    end
	end
end
