module Mangdown 

	extend self

  def to_s
		"<#{self.class}::#{self.object_id}" <<
		@name ? " : #{@name}" : '' <<
		name  ? " : #{name}"  : '' <<
		@uri  ? "	: #{@uri}"  : '' <<
		uri   ? " : #{uri}"   : '' <<
		">"
	end

  def eql?(other)
    (self.name == other.name) and (self.uri == other.uri)
  end

	def ==(other)
		puts "You may want to use :eql?"
		super
	end
end

