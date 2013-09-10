require_relative '../../lib/mandown'

#Page features

When(/^The program downloads an image$/) do
  uri = 'http://i25.mangareader.net/bleach/537/bleach-4149721.jpg'
  filename = 'Bleach 537 - Page 1'
  @page = Mandown::Page.new( uri, filename )
  @page.download
end

Then(/^The image will be in the current directory$/) do
  dir = Dir.pwd
  expect(Dir.glob(dir + '/*')).to include(dir + '/' + @page.filename)
end

Then(/^It will be an image file$/) do
  expect(@page.filename).to include(".jpg")
end


#Chapter features

When(/^The program downloads a chapter$/) do
  uri = 'http://www.mangareader.net/bleach/537'
  chaptername = 'Bleach 537'
  @chapter = Mandown::Chapter.new( uri, chaptername )
  @chapter.download
end

Then(/^A directory will be created in the current directory$/) do
  dir = Dir.pwd
  expect(Dir.glob(dir + '/*')).to include(dir + '/' + @chapter.name)  
end

Then(/^It will contain the images \(Page\) in the chapter$/) do
  dir = Dir.pwd + '/' + @chapter.name
  @chapter.pages.each do |page|
    expect(Dir.glob(dir + '/*')).to include(dir + '/' + page.filename)
  end
end

