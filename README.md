## Adapters
Check out lib/mangdown/adapters/mangareader.rb and lib/mangdown/adapters/mangabat.rb for examples of how to build an adapter.

### Register an adapter

```
# Register an adapter (AdapterClass) with the name :name
Mangdown.register_adapter(:name, AdpaterClass.new)
```

### Bundled adapters
There are only two adapters bundled with mangdown, but it is fairly simple to create one, so go ahead and give it a try. Feel free to file an issue if you have any problems.

There is a simple built-in client, "Mangdown::Client", that you can use for finding manga:

```ruby
require 'mangdown/client'

# Search for an exact match
results = Mangdown::Client.find("Dragon Ball")

# Or if you need more flexibilty when searching for a manga,
# use the db models directly
results = Mangdown::DB::Manga.where(name: 'Bleach').map do |record|
  Mangdown.manga(record.url)
end

# Get a Mangdown::Manga object
manga = results.first

# Get a chapter count
manga.chapter.length

# Download everything
manga.download

# Download a specific range
manga.download(0, 99)

# Download to a specific dir
manga.download_to('path/to/downloads', 0, 99)

# Convert all downloaded chapters to CBZ
manga.cbz

```
