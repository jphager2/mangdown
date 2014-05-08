require 'spec_helper'

module Mangdown
  @@chapter_hash = MDHash.new(
    uri: 'http://www.mangareader.net/bleach/537',
    name: 'Bleach 537'
	)

	chapter = @@chapter_hash.to_chapter
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
        expect(@chapter.uri).to eq(@@chapter_hash[:uri])
      end

      it "should get pages when initialized" do
        expect(@chapter.pages.size).to be > 0
      end

      it "should have the right first page at the 0 index" do
        expect(@chapter.pages.first.name).to eq(
               'Bleach 537 - Page 1.jpg')  
      end

      it "should have the right last page at the -1 index" do
        expect(@chapter.pages.last.name).to eq(
               'Bleach 537 - Page 21.jpg')
      end

      context "as a MFChapter" do
        it "should have pages" do
          hash = MDHash.new(
            uri:  'http://mangafox.me/manga/kitsune_no_yomeiri/v01/c001/1.html',
            name: 'Kitsune no Yomeiri 1'
					)

					chapter = hash.to_chapter
          
          expect(chapter.pages).not_to be_empty
        end
      end
    end
    
  context "when chapter is downloaded" do
    it "should have a sub directory in the current directory" do
      dir = Dir.pwd
      chapter_path = dir + '/' +  @chapter.name

      expect(Dir.glob(dir + '/*' )).to include(chapter_path)
    end

    it "should download all it's pages" do
      dir = Dir.pwd + '/' + @chapter.name

      pages_in_dir = Dir.glob(dir + '/*.jpg').length
      expect(pages_in_dir).to eq(@chapter.pages.length)
      end
    end
  end
end



