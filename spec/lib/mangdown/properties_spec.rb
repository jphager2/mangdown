require_relative '../../spec_helper'

require_relative '../../spec_helper'

describe Mangdown::Properties do
  let(:mangareader) {
    Mangdown::Properties.new('http://www.mangareader.net/101/akira.html')
  }
  let(:mangafox) {
    Mangdown::Properties.new('"http://mangafox.me/manga/ashita_no_joe/')
  }
  let(:mangapanda) { 
    Mangdown::Properties.new('http://www.mangapanda.com/fairy-tail/424')
  }

  describe 'new' do
    it 'must give the right info' do
      mangareader.type.must_equal(:mangareader)
      mangapanda.type.must_equal( :mangapanda)
      mangafox.type.must_equal(   :mangafox)
    end
  end
end
