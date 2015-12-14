module Mangdown::Uri 

  extend self

  def new(uri)
    URI.encode(uri, '[]')
  end 
end
