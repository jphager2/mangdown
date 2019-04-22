# frozen_string_literal: true

require_relative '../mangdown'

require_relative 'db'

module Mangdown
  # Simple client for Mangdown
  module Client
    module_function

    # return a list of hash with :uri and :name of mangas found in list
    def find(search)
      filter = Sequel.lit('LOWER(name) LIKE ?', "%#{search.downcase}%")
      Mangdown::DB::Manga.where(filter).map do |manga|
        Mangdown.manga(manga.url)
      end
    end

    # cbz all subdirectories in a directory
    def cbz(dir)
      Mangdown::CBZ.all(dir)
    rescue StandardError => error
      raise Mangdown::Error, "Failed to package #{dir}: #{error.message}"
    end

    # load manga into sqlite db
    def index_manga
      count_before = Mangdown::DB::Manga.count

      Mangdown.adapters.each do |name, adapters|
        adapters.manga_list.each do |manga|
          manga = Mangdown::DB::Manga.find_or_create(
            adapter: name,
            url: manga.url,
            name: manga.name
          )
        end
      end

      count_after = Mangdown::DB::Manga.count

      puts "#{count_after} manga, #{count_after - count_before} new"
    end
  end
end
