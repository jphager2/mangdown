require 'spec_helper'

module Mangdown
  @@uri = 'http://www.mangareader.net/bleach/537'
  @@chapter_name = 'Bleach 537'

  chapter = MRChapter.new( @@uri, @@chapter_name )
  chapter.download
  
  STUB_PATH = File.expand_path('../../objects/chapter.yml', __FILE__)
  File.open(STUB_PATH, 'w+') do |file| 
    file.write(chapter.to_yaml)
  end

  describe MRChapter do
    before(:each) do
      print 'o'
      @chapter = YAML.load(File.open(Mangdown::STUB_PATH, 'r').read)
    end

    context "when chapter is initialized" do
      # sanity check, not necessary
      it "should have the right chapter uri" do
        expect(@chapter.uri).to eq(@@uri)
      end

      it "should get pages when initialized" do
        expect(@chapter.pages.size).to be > 0
      end

      it "should have the right first page at the 0 index" do
        expect(@chapter.pages.first.filename).to eq(
               'Bleach 537 - Page 1.jpg')  
      end

      it "should have the right last page at the -1 index" do
        expect(@chapter.pages.last.filename).to eq(
               'Bleach 537 - Page 21.jpg')
      end
    end
    
   # Move these to Tools spec 
=begin
    context "when the functions for get_pages are run" do
      it "should have the right chapter uri" do
        expect(@chapter.uri).to eq(@@uri)
      end

      it "should get the right image link and filename from a uri" do
        expect(@chapter.get_page).to eq(
              ['http://i25.mangareader.net/bleach/537/bleach-4149721.jpg',
               'Bleach 537 - Page 1'])
      end
    
      it "should get the right root from uri" do
        expect(@chapter.get_root(@@uri)).to eq('http://www.mangareader.net')
      end
    end
=end

  context "when chapter is downloaded" do
    it "should have a sub directory in the current directory" do
      dir = Dir.pwd
      expect(Dir.glob(dir + '/*' )).to include(dir + '/' + 
                                               @chapter.name)
    end

    it "should download all it's pages" do
      dir = Dir.pwd + '/' + @chapter.name
      # expect(dir).to include("mangdown/#{@chapter.name}")
      pages_in_dir = Dir.glob(dir + '/*.jpg').length
      expect(pages_in_dir).to eq(@chapter.pages.length)
      #@chapter.pages.each do |page|
      #  expect(Dir.glob(dir + '/*' )).to include(dir + 
      #                                           '/' + page.filename)
      end
    end
  end
end



