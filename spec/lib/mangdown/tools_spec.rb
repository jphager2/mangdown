require_relative '../../spec_helper'

describe Mangdown::Tools do
  let(:m_uri)  { "http://mangafox.me/manga/romance_dawn/" }

  let(:c_uri)  { "http://www.mangareader.net/onepunch-man/1" }

  let(:c2_uri)  { "http://mangafox.me/manga/naruto/v57/c542/1.html" }

  let(:p_uri)  { 
    "http://i1.mangareader.net/hikaru-no-go/1/hikaru-no-go-1894067.jpg" 
  }

  before do
    VCR.insert_cassette 'events', record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'get_doc' do
    it 'must return a Nokogiri Document' do
      Mangdown::Tools.get_doc(m_uri)
        .must_be_instance_of(Nokogiri::HTML::Document)
    end
  end

  describe 'get_root' do
    it 'must return the protocol and host of the uri' do
      Mangdown::Tools.get_root(m_uri)
        .must_equal('http://mangafox.me')
      Mangdown::Tools.get_root(c_uri)
        .must_equal('http://www.mangareader.net')
      Mangdown::Tools.get_root(c2_uri)
        .must_equal('http://mangafox.me')
      Mangdown::Tools.get_root(p_uri)
        .must_equal('http://i1.mangareader.net')
    end
  end
end
