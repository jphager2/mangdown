require_relative '../../spec_helper'

describe Mangdown::Uri do
  let(:m_uri)  { "http://mangafox.me/manga/romance_dawn/" }

  let(:c_uri)  { "http://www.mangareader.net/onepunch-man/1" }

  let(:c2_uri)  { "http://mangafox.me/manga/naruto/v57/c542/1.html" }

  let(:p_uri)  { 
    "http://i1.mangareader.net/hikaru-no-go/1/hikaru-no-go-1894067.jpg" 
  }

  describe 'get_doc' do
    it 'must return a String object' do
      Mangdown::Uri.new(m_uri).must_be_instance_of(String)
    end

    it 'must return a properly encoded uri' do
    end
  end
end
