# frozen_string_literal: true

module Mangdown
  module DB
    # DB model for manga
    class Manga < Sequel::Model(Mangdown::DB::CONNECTION[:manga])
    end
  end
end
