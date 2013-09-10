require 'spec_helper'

module Mandown
  describe Chapter do
    context "when chapter is downloaded" do
      it "should create a directory in the current directory" do
	uri = 'http://www.mangareader.net/bleach/537'
	chaptername = 'Bleach 537'
	chapter = Chapter.new( uri, chaptername )
	chapter.download
	dir = Dir.pwd
	expect(Dir.glob(dir + '/*' )).to include(dir + '/' + chapter.name)
      end

      it "should download all it's pages" do
	uri = 'http://www.mangareader.net/bleach/537'
	chaptername = 'Bleach 537'
	chapter = Chapter.new( uri, chaptername )
	chapter.download
	dir = Dir.pwd + '/' + chapter.name
	chapter.pages.each do |page|
	  expect(Dir.glob(dir + '/*' )).to include(dir + '/' + page.filename)
	end
      end
    end
  end
end
