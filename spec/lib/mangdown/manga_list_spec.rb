require_relative '../../spec_helper.rb'

describe Mangdown::MangaList do
  before do
    VCR.insert_cassette 'events', record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'new' do
    let(:mangareader) {
      Mangdown::MangaList.new('http://www.mangareader.net/alphabetical')
    }
    let(:mangafox) { 
      Mangdown::MangaList.new('http://mangafox.me/manga/')
    }
    let(:multiple) { Mangdown::MangaList.new(
      'http://www.mangareader.net/alphabetical',
      'http://mangafox.me/manga/'
    ) }

    it 'must have a manga list with mangas (as md hashes)' do
      [mangareader, mangafox].each do |type|
        type.mangas.must_be_instance_of Array
        type.mangas.each do |manga|
          manga.must_be_instance_of Mangdown::MDHash
        end
      end
    end

    it 'must raise an ArgumentError if given a bad url' do
      -> { Mangdown::MangaList.new('garbage-url.com/bogus') }
        .must_raise ArgumentError
    end

    it 'must return a manga list with mangas from all input urls' do
      multiple.mangas.length.must_be :>, (mangareader.mangas.length)
    end
  end
end
