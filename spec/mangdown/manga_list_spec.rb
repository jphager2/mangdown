require 'spec_helper.rb'

module Mangdown 
  describe MangaList do
    before do
      @manga_list = MangaList.new(
                    'http://www.mangareader.net/alphabetical')
    end

    subject {@manga_list}

    it "should not have an empty manga list" do
      expect(subject.mangas).to_not be_empty 
    end
  end
end
    
