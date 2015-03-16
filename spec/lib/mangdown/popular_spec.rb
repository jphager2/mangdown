require_relative '../../spec_helper'

describe Mangdown::PopularManga do
  let(:mangareader) { 
    Mangdown::PopularManga.new('http://www.mangareader.net/popular')
  }

  before do
    VCR.insert_cassette 'events', record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'new' do
    it 'must have a list of mangas'  do
      mangareader.mangas.wont_be(:empty?)
    end
  end
end
