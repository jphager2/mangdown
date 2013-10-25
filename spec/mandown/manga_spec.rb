require_relative '../spec_helper'

module Mandown
  describe Manga do
    context "When a manga is initialized" do
      before(:all) do
        @manga = Manga.new('http://www.mangareader.net/94/bleach.html', 'Bleach')
      end

      it "should have chapters" do
        expect(@manga.chapters).not_to be_empty
      end
    end

    context "with Bleach manga" do
      before(:all) do
        @manga = Manga.new('http://www.mangareader.net/94/bleach.html', 'Bleach')
      end

      it "should have more that 500 chapters" do

      end

      it "should have the right first and 300th chapter" do

      end
    end
  end
end
