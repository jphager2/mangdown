require 'spec_helper'

module Mangdown

  describe MDHash do
    before(:all) do
      @hash = MDHash.new
      @hash[:uri] = 'http://www.mangareader.net/103/one-piece.html'
      @hash[:name] = 'One Piece'
    end

    it "should get a manga object from get_manga" do
      expect(@hash.get_manga).to be_kind_of(Manga)
    end
  end
end
