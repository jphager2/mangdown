require_relative '../../lib/mangdown'

class AddTables < ActiveRecord::Migration
  def up
    create_table :sites do |t|
      t.string :name
      t.string :uri
    end

    Site.create({                                     #1
      name: 'mangareader', 
      uri: 'http://www.mangareader.net/alphabetical',
    })
    Site.create({                                     #2
      name: 'mangafox',
      uri:  'http://mangafox.me/manga/',
    }) 

    create_table :mangas do |t|
      t.string  :name
      t.string  :uri
      t.integer :site_id
    end

    mangareader = Mangdown::MangaList.new( Site.find(1).uri )
    mangafox    = Mangdown::MangaList.new( Site.find(2).uri )

    mangareader.mangas.each do |md_hash|
      Manga.create(md_hash.merge( {site_id: 1}))
    end

    mangafox.mangas.each do |md_hash|
      Manga.create(md_hash.merge( {site_id: 2}))
    end

    create_table :chapters do |t|
      t.string  :name
      t.string  :uri
      t.integer :manga_id
    end

    create_table :pages do |t|
      t.string  :name
      t.string  :uri
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
