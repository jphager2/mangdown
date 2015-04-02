require_relative '../../spec_helper.rb'

describe Mangdown::Page do
  before do
    VCR.insert_cassette 'events', record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'new' do
    let(:download_path) {File.expand_path('../../../../tmp', __FILE__)}
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

    it 'must have a valid name' do
      [mangareader, mangafox, mangafox2].each do |type|
        type.name.must_match(/\d{3}\.jpg$/)
      end
    end

    it 'must download image to dir' do
      [mangareader, mangafox, mangafox2].each do |type|
        type.download_to(download_path)
        path   = "#{download_path}/#{type.name}"
        exists = File.exist?(path)
        exists.must_equal true
        File.delete(path) if exists
      end
    end

    it 'must sort pages by name' do
      pages        = [mangareader, mangafox, mangafox2] * 20
      sorted       = pages.shuffle.sort
      sort_by_name = pages.shuffle.sort_by(&:name)

      sorted.must_equal sort_by_name
    end
  end
end
