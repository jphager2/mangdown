class TestAdapter < Mangdown::Adapter::Base

  site :test

  def self.for?(url_or_site)
    true
  end

  # Overwrite if you want to check the uri if it belongs to a manga list
  def is_manga_list?(uri = @uri)
    true
  end

  # Must return true/false if uri represents a manga for adapter
  def is_manga?(uri = @uri)
    true
  end

  # Must return true/false if uri represents a chapter for adapter
  def is_chapter?(uri = @uri)
    true
  end

  # Must return true/false if uri represents a page for adapter
  def is_page?(uri = @uri)
    true
  end

  # Return Array of Hash with keys: :uri, :name, :site
  def manga_list
    [ 
      { uri: "http://www.manga.com/naruto", name: "Naruto", site: site },
      { uri: "http://www.manga.com/bleach", name: "Bleach", site: site },
      { uri: "http://www.manga.com/one-piece", name: "One Piece", site: site }
    ]
  end

  # Return Hash with keys: :uri, :name, :site
  def manga
    { uri: "http://www.manga.com/naruto", name: "Naruto", site: site }
  end

  # Return Array of Hash with keys: :uri, :name, :site
  def chapter_list
    [ 
      { uri: "http://www.manga.com/naruto/1", name: "Naruto", site: site },
      { uri: "http://www.manga.com/naruto/2", name: "Naruto", site: site },
      { uri: "http://www.manga.com/naruto/3", name: "Naruto", site: site },
      { uri: "http://www.manga.com/naruto/4", name: "Naruto", site: site },
      { uri: "http://www.manga.com/naruto/5", name: "Naruto", site: site }
    ]
  end

  # Return Hash with keys: :uri, :name, :chapter, :manga, :site
  def chapter
    { uri: "http://www.manga.com/naruto/2",
      name: "Naruto - Chapter 2",
      chapter: 2,
      manga: "Naruto",
      site: site
    }
  end

  # Return Array of Hash with keys: :uri, :name, :site
  def page_list
    [ 
      {
        uri: "http://www.manga.com/naruto/2/page/1",
        name: "Naruto - Chapter 2 - page 1",
        site: site
      },
      {
        uri: "http://www.manga.com/naruto/2/page/2",
        name: "Naruto - Chapter 2 - page 2",
        site: site
      },
      {
        uri: "http://www.manga.com/naruto/2/page/3",
        name: "Naruto - Chapter 2 - page 3",
        site: site
      },
      {
        uri: "http://www.manga.com/naruto/2/page/4",
        name: "Naruto - Chapter 2 - page 4",
        site: site
      },
      {
        uri: "http://www.manga.com/naruto/2/page/5",
        name: "Naruto - Chapter 2 - page 5",
        site: site
      }
    ]
  end

  # Return Hash with keys: :uri, :name, :site
  def page
    path = File.expand_path("../fixtures/images/naruto.jpg", __FILE__)
    { uri: path, name: "Naruto - Chapter 2 - page 2", site: site }
  end

  def doc
    @doc
  end
end

