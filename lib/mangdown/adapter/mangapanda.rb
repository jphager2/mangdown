require_relative 'mangareader'

module Mangdown
  class Mangapanda < Mangareader
    def initialize(uri, doc)
      @root = 'http://www.mangapanda.com'
      super
    end
  end
end

