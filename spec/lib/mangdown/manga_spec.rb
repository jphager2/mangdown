require_relative '../../spec_helper'

describe Mangdown::Manga do
  let(:download_path) { File.expand_path('../../../../tmp', __FILE__) }
  let(:manga_name) { "Romance Dawn" }
  let(:uri)  { 
    "http://mangafox.me/manga/romance_dawn/" 
  }

  before do
    VCR.insert_cassette 'events', record: :new_episodes
    @manga =  Mangdown::Manga.new(manga_name, uri)
  end

  after do
    VCR.eject_cassette
    FileUtils.rm_r("#{download_path}/#{manga_name}", force: true)
  end

  describe 'new' do
    it 'must return a manga' do
      @manga.must_be_instance_of Mangdown::Manga
    end

    it 'must have chapters' do
      @manga.chapters.wont_be :empty?
    end
  end

  describe 'download' do
    it 'must download to default download dir' do
      @manga.download

      dir = Mangdown::DOWNLOAD_DIR + "/#{manga_name}"
      Dir.exist?(dir).must_equal true
    end

    it 'must download to the given dir' do
      dir = Mangdown::DOWNLOAD_DIR + '/random'
      Dir.mkdir(dir)
      @manga.download_to(dir)

      Dir.exist?(dir + "/#{manga_name}").must_equal true

      FileUtils.rm_r(dir, force: true)
    end

    it 'must download the right number of chapters' do
      manga = Mangdown::Manga
        .new('Gantz', 'http://www.mangareader.net/97/gantz.html')
      manga.download(50, 52)

      chapters = Dir[Mangdown::DOWNLOAD_DIR + '/Gantz/*/']
      chapters.length.must_equal 3

      FileUtils.rm_r(Mangdown::DOWNLOAD_DIR + '/Gantz', force: true)
    end
  end
end
