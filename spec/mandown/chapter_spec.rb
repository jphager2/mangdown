require 'spec_helper'

module Mandown
  describe Chapter do
    before do
      @uri = 'http://www.mangareader.net/bleach/537'
      @chaptername = 'Bleach 537'
      @chapter = Chapter.new( @uri, @chaptername )
      @chapter.get_doc(@uri)
   end

   context "when chapter is initialized" do
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

    it "should evaluate the expression to stop the loop in get_pages correctly" do
      expect(@chapter.get_doc('http://www.mangareader.net/bleach/538')).not_to eq(
              @chapter.name)
    end
    
    context "when chapter is downloaded" do
      before do
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

      after do
        dir = Dir.pwd + '/' + @chapter.name
        Dir.rmdir(dir) if Dir.exist?(dir) 
      end
    end
  end
end
