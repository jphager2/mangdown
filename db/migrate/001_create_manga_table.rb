# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:manga) do
      primary_key :id
      String :adapter, null: false
      String :url, null: false
      String :name, null: false
    end
  end
end
