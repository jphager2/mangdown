require_relative 'spec_helper'

describe PopularManga do
  before(:all) do
    @list = [20, 50, 90]
    @num = 0
  end

  context "when initialized" do
    before(:each) do 
      @pop = PopularManga.new('http://www.mangareader.net/popular',@list[@num])
      @num += 1
    end

    context "with top 20" do
      it "should have a manga list with top 20 mangas" do
        expect(@pop.mangas_list.length).to eq(20)
      end
    end

    context "with top 50"
      it "should have a manga list with top 50 mangas" do
        expect(@pop.mangas_list.length).to eq(50)
      end
    end

    context "with top 90" do
      it "should have a manga list with top 90 mangas" do
        expect(@pop.mangas_list.length).to eq(90)
      end
    end

    it "should have an empty mangas array" do
      expect(@pop.mangas).to be_empty
    end
  end

  context "when get_manga is called" do
    it "should have 1 manga in mangas" do
      @pop.get_manga(1)
      expect(@pop.mangas.length).to eq(1)
    end

    it "should have 2 mangas in mangas" do
      @pop.get_manga(1)
      @pop.get_manga(2)
      expect(@pop.mangas.length).to eq(1)
    end

    it "should have Bleach in mangas" do
      @pop.get_manga(1)
      expect(@pop.mangas.length).to eq(1)
    end

    it "should only get manga once" do
      @pop.get_manga(1)
      @pop.get_manga(1)
      expect(@pop.mangas.length).to eq(1)
    end
  end
end
