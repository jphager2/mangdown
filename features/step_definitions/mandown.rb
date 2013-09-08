
When(/^The program downloads an image$/) do
  uri = 'http://i25.mangareader.net/bleach/537/bleach-4149721.jpg'
  filename = 'Bleach 537 - Page 1'
  @page = Page.new( uri, filename )
  @page.download
end

Then(/^The image will be in the current directory$/) do
  dir = Dir.pwd
  expect(Dir.globe(dir + '*')).to include(@page.filename)
end
