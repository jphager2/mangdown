require_relative '../../lib/mandown'

When(/^The program downloads an image$/) do
  uri = 'http://i25.mangareader.net/bleach/537/bleach-4149721.jpg'
  filename = 'Bleach 537 - Page 1'
  @page = Mandown::Page.new( uri, filename )
  @page.download
end

Then(/^The image will be in the current directory$/) do
  dir = Dir.pwd
  expect(Dir.glob(dir + '/' + '*')).to include(dir + '/' + @page.filename)
end
