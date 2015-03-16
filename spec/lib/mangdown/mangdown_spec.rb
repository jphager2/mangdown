require_relative '../../spec_helper.rb'

describe Mangdown do
  before do
    VCR.insert_cassette 'events', record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'eql?' do
    it 'should return true when two objects are symatically equal' do
      monster1 = M.find('monster').first
      monster2 = M.find('monster').first
      (monster1 == monster2).must_equal(false)
      (monster1.eql?(monster2)).must_equal(true)
    end

    it 'should return true when two objects are symantically unequal' do
      monster1 = M.find('monster').first
      monster2 = M.find('20th century boys').first
      (monster1 == monster2).must_equal(false)
      (monster1.eql?(monster2)).must_equal(false)
    end

    it 'should return true even if different classes' do
      monster1 = M.find('monster').first
      monster2 = monster1.to_manga
      (monster1 == monster2).must_equal(false)
      (monster1.eql?(monster2)).must_equal(true)
    end
  end
end

