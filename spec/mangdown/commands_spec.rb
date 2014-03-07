require 'spec_helper.rb'

module M

  describe "commands" do
		before(:all) do
      hash = MDHash.new
      hash[:uri]  = 'http://www.mangareader.net/6-no-trigger'
      hash[:name] = '6 no Trigger'
      @manga = Manga.new(hash)
      
      hash = MDHash.new
      hash[:uri]  = 'http://mangafox.me/manga/naruto/'
      hash[:name] = 'Naruto'
      @mf_manga = Manga.new(hash)

	   	M.download(@manga, 1, 3)
			M.cbz("./#{@manga.name}")
	  end

	  it "should find a manga with the find command" do
			m = M.find('Naruto')
			expect(m.first[:name]).to eq('Naruto')
		end

		it "should find a list of manga with the find command" do
			m = M.find('Trigger')
			expect(m.length).to be > 1
		end

    it "should find a manga from MF" do
      m = M.find('naruto')
      mangafox_hash_found = m.find {|hash| hash[:uri] =~ /mangafox/}
      expect(mangafox_hash_found).not_to be_nil
    end

    #for sanity
    it "should create a list of MDHash" do 
      expect(@mf_manga.chapters_list[10]).to be_kind_of(MDHash)
    end

    it "should create MFChapter for mf manga" do
      @mf_manga.get_chapter(10)
      expect(@mf_manga.chapters.first).to be_kind_of(MFChapter)
    end

    it "should download a manga from MF" do 
      dir = Dir.pwd
      M.download(@mf_manga, 500, 501)
      expect(Dir.glob(dir + "/#{@mf_manga.name}/*").length).to eq(3)
    end

		it "should download a manga with the download command" do
		  chps = Dir.glob("#{Dir.pwd}/#{@manga.name}/*/")	
			expect(chps.length).to eq(3)
		end

		it "should cbz a manga with the cbz command" do
		  cbz_s = Dir.glob("#{Dir.pwd}/#{@manga.name}/*.cbz") 	
			expect(cbz_s.length).to eq(3)
		end
	end
end
