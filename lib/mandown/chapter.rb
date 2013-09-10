require_relative 'page'

module Mandown
  class Chapter
    attr_reader :name, :pages
    def initialize( uri, name )
      @uri = uri
      @name = name
      @pages = []
    end

    def download
      Dir.mkdir(@name) unless Dir.exists?(@name)
    end
  end
end  
