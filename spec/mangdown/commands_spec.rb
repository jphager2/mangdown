require 'spec_helper.rb'

module M

  describe "commands" do
		before(:all) do
	   	@manga = Mangdown::Manga.new('http://www.mangareader.net/6-no-trigger',
												 '6 NO TRIGGER')
			
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

		it "should download a manga with the download command" do
			puts Dir.pwd
		  chps = Dir.glob("#{Dir.pwd}/#{@manga.name}/*/")	
			expect(chps.length).to eq(3)
		end

		it "should cbz a manga with the cbz command" do
		  cbz_s = Dir.glob("#{Dir.pwd}/#{@manga.name}/*.cbz") 	
			expect(cbz_s.length).to eq(3)
		end
	end
end
