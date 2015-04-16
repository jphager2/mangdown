require_relative '../../spec_helper'

describe Mangdown::Manga do
  let(:m_name) { "Romance Dawn" }
  let(:m_uri)  { "http://mangafox.me/manga/romance_dawn/" }

  let(:c_name) { "Onepunch-Man 1" }
  let(:c_uri)  { "http://www.mangareader.net/onepunch-man/1" }

  let(:c2_name) { "Naruto 542" }
  let(:c2_uri)  { "http://mangafox.me/manga/naruto/v57/c542/1.html" }

  let(:p_name) { "Hikaru No Go 1 - Page 1.jpg" }
  let(:p_uri)  { 
    "http://i1.mangareader.net/hikaru-no-go/1/hikaru-no-go-1894067.jpg" 
  }

  before do
    VCR.insert_cassette 'events', record: :new_episodes
    @md_page    =  Mangdown::MDHash.new(uri: p_uri, name: p_name)
    @md_chapter =  Mangdown::MDHash.new(uri: c_uri, name: c_name)
    @md_manga   =  Mangdown::MDHash.new(uri: m_uri, name: m_name)
  end

  after do
    VCR.eject_cassette
  end

  describe 'new' do
    it 'must return a manga' do
      [@md_page, @md_chapter, @md_manga].each do |type|
        type.must_be_instance_of Mangdown::MDHash
      end
    end
  end

  describe 'to_manga' do
    it 'must give a manga for a manga' do
      @md_manga.to_manga.must_be_instance_of Mangdown::Manga
    end

    it 'must raise an exception if not a manga' do
      [@md_chapter, @md_page].each do |type|
        Proc.new { type.to_manga }.must_raise NoMethodError
      end
    end
  end

  describe 'to_chapter' do
    it 'must give a chapter' do
      @md_chapter.to_chapter.must_be_instance_of Mangdown::Chapter
    end

    it 'must raise an exception if not a chapter' do
      [@md_page, @md_manga].each do |type|
        Proc.new { type.to_chapter }.must_raise NoMethodError
      end
    end
  end

  describe 'to_page' do
    it 'must give a page for a page' do
      @md_page.to_page.must_be_instance_of Mangdown::Page
    end

    it 'must raise an exception if not a page' do
      [@md_chapter, @md_manga].each do |type|
        Proc.new { type.to_page }.must_raise NoMethodError
      end
    end
  end
end
