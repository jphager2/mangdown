module Mandown
   def new_chapter
    @count ||= 0
    @count += 1
    print "!#{@count}"
    @uri = 'http://www.mangareader.net/bleach/537'
    @chaptername = 'Bleach 537'
    @chapter = Chapter.new( @uri, @chaptername )
    @chapter.get_doc(@uri)
  end
end
