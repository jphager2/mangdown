class AddSites < ActiveRecord::Migration
  def up
    create_table :sites do |t|
      t.string :name
      t.string :url
    end
  end

  def down
    drop_table :sites
  end
end
