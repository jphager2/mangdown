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

	@@fc_uri = 'http://www.fakku.net/doujinshi/pipiruma-extra-edition-dokidoki-summer-vacation/read#page=1'
	@@fc_chapter_name = 'Pipiruma! Extra Edition -DokiDoki Summer Vacation-'
  @@fc_num_pages = 26

	f_chapter = FKChapter.new( @@fc_uri, @@fc_chapter_name, @@fc_num_pages)
	f_chapter.download

	FC_STUB_PATH = File.expand_path('../../objects/f_chapter.yml', __FILE__)
  File.open(FC_STUB_PATH, 'w+') do |file| 
    file.write(f_chapter.to_yaml)
  end

  describe MRChapter do
    before(:each) do
      print 'o'
      @chapter = YAML.load(File.open(Mangdown::STUB_PATH, 'r').read)
      @chapter.get_doc(@@uri)
    end

    context "when chapter is initialized" do
      it "should have the right chapter uri" do
        expect(@chapter.uri).to eq(@@uri)
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
      it "should have the right chapter uri" do
        expect(@chapter.uri).to eq(@@uri)
      end

			# Probably can get rid of this, not using chapter_mark for functionality
			#	xit "should get the right chapter mark from a uri" do
			#		expect(@chapter.get_chapter_mark).to eq('Bleach 537')
			#	end

      it "should get the right image link and filename from a uri" do
        expect(@chapter.get_page).to eq(
              ['http://i25.mangareader.net/bleach/537/bleach-4149721.jpg',
               'Bleach 537 - Page 1'])
      end
    
      it "should get the right root from uri" do
        expect(@chapter.get_root(@@uri)).to eq('http://www.mangareader.net')
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
      it "should have the right chapter uri" do
        expect(@chapter.uri).to eq(@@uri)
      end

      it "should create a directory in the current directory" do
        dir = Dir.pwd
	      expect(Dir.glob(dir + '/*' )).to include(dir + '/' + @chapter.name)
      end

      it "should download all it's pages" do
	      dir = Dir.pwd + '/' + @chapter.name
        expect(dir).to include("mangdown/#{@chapter.name}")
	      @chapter.pages.each do |page|
	        expect(Dir.glob(dir + '/*' )).to include(dir + '/' + page.filename)
	      end
      end
    end
  end

	describe FKChapter do
    before(:each) do
      @f_chapter = YAML.load(File.open(Mangdown::FC_STUB_PATH, 'r').read) 
			@f_chapter.get_doc(@@fc_uri)
	  end

		it 'should be downloaded' do
      dir = File.expand_path("../../../#{@f_chapter.name}", __FILE__)
			expect(dir).to include("mangdown/#{@f_chapter.name}")
			@f_chapter.pages.each do |page|
				expect(Dir.glob(dir + '/*')).to include(dir + '/' + page.filename)
			end
		end
	end
end



