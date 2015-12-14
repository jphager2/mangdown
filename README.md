![Gitten badge](http://gittens.r15.railsrumble.com//badge/jphager2/mangdown)

There is a simple built-in client, "M", that you can use for finding manga:

```
results = M.find("Dragon Ball")

# Get a Mangdown::Manga object
manga = results.first.to_manga

# Get a chapter count
manga.count

# Download everything
manga.download

# Download a specific range 
manga.download(0, 99)

# Convert all downloaded chapters to CBZ
manga.cbz

```
