require_relative '../../spec_helper.rb'

describe Mangdown::Page do
  before do
    VCR.insert_cassette 'events', record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'new' do
    let(:mangareader) {
      Mangdown::Page.new(
        "Naruto 1 - Page 1.jpg",
        "http://i19.mangareader.net/naruto/1/naruto-1564773.jpg"
      )
    }
    let(:mangafox) { 
      Mangdown::Page.new(
        "i001.jpg",
        "http://a.mfcdn.net/store/manga/10807/000.0/compressed/i001.jpg"
      )
    }
    let(:mangafox2) {
      Mangdown::Page.new(
        "naruto_pilot_manga.naruto_pilot_01.jpg",
        "http://a.mfcdn.net/store/manga/8/01-000.0/compressed/naruto_pilot_manga.naruto_pilot_01.jpg"
      )
    }

    it 'have a valid name' do
      [mangareader, mangafox, mangafox2].each do |type|
        type.name.must_match(/\d{3}\.jpg$/)
      end
    end
  end
end
