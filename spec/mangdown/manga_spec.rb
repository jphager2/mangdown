require_relative '../spec_helper'

module Mangdown
  @@m_uri = 'http://www.mangareader.net/94/bleach.html'
  @@manga_name = 'Bleach'

  manga = Manga.new( @@m_uri, @@manga_name )
  
  MANGA_STUB_PATH = File.expand_path('../../objects/manga.yml', __FILE__)
  File.open(MANGA_STUB_PATH, 'w+') do |file| 
    file.write(manga.to_yaml)
  end


  describe Manga do
    before(:each) do
      print '@'
      @manga = YAML.load(File.open(Mangdown::MANGA_STUB_PATH, 'r').read)
      @manga.get_doc(@@m_uri)
    end

    context "When a manga is initialized" do
      it "should not have chapters" do
        expect(@manga.chapters).to be_empty
      end

      it "should have chapters listed in chapters_list" do
        expect(@manga.chapters_list).not_to be_empty
      end

      context "as a MangaFox manga" do
        it "should have chapters" do
          manga = Manga.new(
            'http://mangafox.me/manga/masca_the_beginning/', 
            'Masca: The Beginning'
          )
          expect(manga.chapters_list).not_to be_empty
        end
      end
    end

    context "with Bleach manga" do
      it "should have more that 500 chapters" do
        expect(@manga.chapters_list.length).to be > 500
      end

      it "should have the right first chapter" do
        expect(@manga.chapters_list.first).to eq({
          uri:'http://www.mangareader.net/94-8-1/bleach/chapter-1.html',
          name: 'Bleach 1'})
      end

      it "should have the right 465th chapter" do
        expect(@manga.chapters_list[464]).to eq({
          uri: 'http://www.mangareader.net/bleach/465',
          name: 'Bleach 465'})
      end
    end

    context "when a chapter is retrieved" do
      before(:all) do
				@manga2 = YAML.load(File.open(Mangdown::MANGA_STUB_PATH, 'r').read)
        @manga2.get_chapter(0)
				@mchapter = @manga2.chapters_list[0]
      end

      it "should have a chapter in chapters" do
        expect(@manga2.chapters.length).to eq(1)
      end

      it "should have chapter 1 in chapters" do
        expect(@manga2.chapters[0].name).to eq(@mchapter[:name])
      end

			it "should have the right chapter sub class" do
				klass = Chapter
				if @mchapter[:uri].include?('mangareader')
					klass = MRChapter
				end
				
				expect(@manga2.chapters[0].class).to eq(klass)
			end
    end
  end
end
