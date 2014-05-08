   # Move these to a Tools spec 
=begin
    context "when the functions for get_pages are run" do
      it "should have the right chapter uri" do
        expect(@chapter.uri).to eq(@@uri)
      end

      it "should get the right image link and name from a uri" do
        expect(@chapter.get_page).to eq(
              ['http://i25.mangareader.net/bleach/537/bleach-4149721.jpg',
               'Bleach 537 - Page 1'])
      end
    
      it "should get the right root from uri" do
        expect(@chapter.get_root(@@uri)).to eq('http://www.mangareader.net')
      end
    end
=end


