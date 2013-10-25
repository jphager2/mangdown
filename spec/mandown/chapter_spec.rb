require 'spec_helper'

module Mandown
  describe Chapter, :help => :chapter do 
    context "when chapter is initialized" do
      before(:all) do
        new_chapter
      end

      it "should have the right chapter uri" do
        expect(@chapter.uri).to eq(@uri)
      end

      it "should get pages when initialized" do
        expect(@chapter.pages.size).to be > 0
      end

      it "should have the first page at the 0 index" do
        expect(@chapter.pages.first.filename).to eq('Bleach 537 - Page 1.jpg')  
      end

      it "should have the last page at the -1 index" do
        expect(@chapter.pages.last.filename).to eq('Bleach 537 - Page 21.jpg')
      end
    end
    
    context "when the functions for get_pages are run" do
      before(:all) do
        new_chapter
      end

      it "should have the right chapter uri" do
        expect(@chapter.uri).to eq(@uri)
      end

      it "should get the right chapter mark from a uri" do
        expect(@chapter.get_chapter_mark).to eq('Bleach 537')
      end

      it "should get the right image link and filename from a uri" do
        expect(@chapter.get_page).to eq(
              ['http://i25.mangareader.net/bleach/537/bleach-4149721.jpg',
               'Bleach 537 - Page 1'])
      end
    
      it "should get the right root from uri" do
        expect(@chapter.get_root(@uri)).to eq('http://www.mangareader.net')
      end

      it "should get the right link to the next page from a uri" do
        expect(@chapter.get_next_uri).to eq(
              'http://www.mangareader.net/bleach/537/2')
      end

      it "should evaluate the expression to stop get_pages" do
        next_chapter_uri = 'http://www.mangareader.net/bleach/538'
        expect(@chapter.get_doc(next_chapter_uri)).not_to eq(@chapter.name)
      end
    end

    context "when chapter is downloaded" do
      before(:all) do
        new_chapter
      end

      it "should have the right chapter uri" do
        expect(@chapter.uri).to eq(@uri)
      end

      before do
        # print '#'
        @chapter.download	
      end

      it "should create a directory in the current directory" do
        dir = Dir.pwd
	expect(Dir.glob(dir + '/*' )).to include(dir + '/' + @chapter.name)
      end

      it "should download all it's pages" do
	dir = Dir.pwd + '/' + @chapter.name
        expect(dir).to include("mandown/#{@chapter.name}")
	@chapter.pages.each do |page|
	  expect(Dir.glob(dir + '/*' )).to include(dir + '/' + page.filename)
	end
      end
    end

  #  after(:all) do
   #   dir = Dir.pwd + '/' + @chapter.name
    #  Dir.rmdir(dir) if Dir.exist?(dir) 
   # end
  end
end
