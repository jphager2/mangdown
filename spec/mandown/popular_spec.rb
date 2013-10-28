require_relative '../spec_helper'

module Mandown
  describe PopularManga do
    before(:all) do
    end

    context "when initialized" do
      before(:each) do 
      end

      context "with top 20" do
        it "should have a manga list with top 20 mangas" do
          @pop2 = PopularManga.new('http://www.mangareader.net/popular', 20)
          expect(@pop2.mangas_list.length).to eq(20)
        end
      end

      context "with top 50" do
        it "should have a manga list with top 50 mangas" do
          @pop3 = PopularManga.new('http://www.mangareader.net/popular', 50)
          expect(@pop3.mangas_list.length).to eq(50)
        end
      end

      context "with top 90" do
        it "should have a manga list with top 90 mangas" do
          @pop4 = PopularManga.new('http://www.mangareader.net/popular', 90)
          expect(@pop4.mangas_list.length).to eq(90)
        end
      end
 
      it "should have an empty mangas array" do
       @pop = PopularManga.new('http://www.mangareader.net/popular', 20)
       expect(@pop.mangas).to be_empty
      end
    end

    context "when get_manga is called" do
      it "should have 1 manga in mangas" do
        @pop = PopularManga.new('http://www.mangareader.net/popular', 20)
        @pop.get_manga(1)
        expect(@pop.mangas.length).to eq(1)
      end

      it "should have 2 mangas in mangas" do
        @pop = PopularManga.new('http://www.mangareader.net/popular', 20)
        @pop.get_manga(1)
        @pop.get_manga(2)
        expect(@pop.mangas.length).to eq(2)
      end

      it "should have Bleach in mangas" do
        @pop = PopularManga.new('http://www.mangareader.net/popular', 20)
        @pop.get_manga(1)
        expect(@pop.mangas.length).to eq(1)
      end

      it "should only get manga once" do
        @pop = PopularManga.new('http://www.mangareader.net/popular', 20)
        @pop.get_manga(1)
        @pop.get_manga(1)
        expect(@pop.mangas.length).to eq(1)
      end
    end
  end
end
