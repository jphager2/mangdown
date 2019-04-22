# frozen_string_literal: true

require 'sequel'
require 'sqlite3'

module Mangdown
  # DB Connection
  module DB
    DB_MIGRATE = File.expand_path('../../db/migrate', __dir__)
    DB_FILE = File.expand_path('../../db/mangdown.db', __dir__)

    unless File.exist?(DB_FILE)
      begin
        SQLite3::Database.new(DB_FILE)
      rescue StandardError
        File.delete(DB_FILE)
        raise
      end
    end

    CONNECTION = Sequel.connect("sqlite://#{DB_FILE}")
    Sequel.extension(:migration)
    Sequel::Migrator.run(CONNECTION, DB_MIGRATE)
  end
end

require_relative 'db/manga'
