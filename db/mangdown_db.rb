module Mangdown
  class DB 
    @@config = YAML.load(ERB.new(File.read('db/config.yml')).result)

    def self.establish_connection
      ActiveRecord::Base.establish_connection(@@config)
    end 

    def self.establish_base_connection
      ActiveRecord::Base.establish_connection(
        @@config.merge(
          {
            "database" => "postgres",
            "schema_search_path" => "public",
          }
        )
      )
    end

    def self.connection
      ActiveRecord::Base.connection
    end

    def self.create_database
      connection.create_database(
        @@config["database"],
        @@config,
      )
    end

    def self.drop_database
      connection.drop_database(
        @@config["database"],
      )
    end

    def self.migrate
      ActiveRecord::Migrator.migrate('db/migrate', nil)
    end
  end
end


