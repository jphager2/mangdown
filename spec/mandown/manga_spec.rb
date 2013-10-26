require_relative '../spec_helper'

module Mandown
  describe Manga do
    context "When a manga is initialized" do
      before(:all) do
        @manga = Manga.new('http://www.mangareader.net/94/bleach.html', 'Bleach')
      end

      it "should have chapters" do
        expect(@manga.chapters).to be_empty
      end

      it "should have chapters listed in chapters_list" do
        expect(@manga.chapters_list).not_to be_empty
      end
    end

    context "with Bleach manga" do
      before(:all) do
        @manga = Manga.new('http://www.mangareader.net/94/bleach.html', 'Bleach')
      end

      it "should have more that 500 chapters" do
        expect(@manga.chapters_list.length).to be > 500
      end

      it "should have the right first chapter" do
        expect(@manga.chapters_list.first).to eq([
                'http://www.mangareader.net/94-8-1/bleach/chapter-1.html',
                'Bleach 1'])
      end

      it "should have the right 465th chapter" do
        expect(@manga.chapters_list[464]).to eq([
                'http://www.mangareader.net/bleach/465',
                'Bleach 465'])
      end
    end

    context "when a chapter is retrieved" do
      before(:all) do
        @manga = Manga.new('http://www.mangareader.net/94/bleach.html', 'Bleach')
        @manga.get_chapter(1)
      end

      it "should have a chapter in chapters" do
        expect(@manga.chapters.length).to eq(1)
      end

      it "should have chapter 1 in chapters" do
        expect(@manga.chapters[0].name).to eq('Bleach 1')
      end
    end
  end
end
