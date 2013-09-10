require 'spec_helper'

module Mandown
  describe Page do
    context "when page is downloaded" do
      it "should download itself to the current directory" do
	dir = Dir.pwd
	uri = 'http://i25.mangareader.net/bleach/537/bleach-4149721.jpg'
	filename = "Bleach 537 - Page 1" 
	page = Page.new( uri, filename )
	page.download
#	puts dir + page.filename
	expect(Dir.glob(dir + '/*')).to include(dir + '/' + page.filename)
      end
    end
  end
end
