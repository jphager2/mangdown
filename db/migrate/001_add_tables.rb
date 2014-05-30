class AddTables < ActiveRecord::Migration
  def up
    create_table :sites do |t|
      t.string :name
      t.string :url
    end

    create_table :mangas do |t|
      t.string  :name
      t.string  :url
      t.integer :site_id
    end

    create_table :chapters do |t|
      t.string  :name
      t.string  :url
      t.integer :manga_id
    end

    create_table :pages do |t|
      t.string  :name
      t.string  :url
      t.integer :chapter_id
    end
  end

  def down
    drop_table :sites
    drop_table :mangas
    drop_table :chapters
    drop_table :pages
  end
end
