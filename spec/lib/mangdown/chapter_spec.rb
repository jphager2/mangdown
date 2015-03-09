require_relative '../../spec_helper'

describe Mangdown::Chapter do
  let(:download_path) { File.expand_path('../../../../tmp', __FILE__) }
  let(:chapter_name) { "Dragon Ball 1" }
  let(:download_chapter_name) { "Dragon Ball 001" }
  let(:uri)  { 
    "http://www.mangareader.net/105-2100-1/dragon-ball/chapter-1.html" 
  }

  before do
    VCR.insert_cassette 'events', record: :new_episodes
    @chapter =  Mangdown::MRChapter.new(chapter_name, uri)
  end

  after do
    VCR.eject_cassette
    FileUtils.rm_r("#{download_path}/#{chapter_name}", force: true)
  end

  describe 'new' do
    it 'must return a kind of Chapter but not an instance of Chapter' do
    end
  end

  describe 'to_chapter' do
    it 'must return the same class of chapter' do
      new_chapter = @chapter.to_chapter
      new_chapter.must_be_instance_of @chapter.class
    end
  end

  describe 'each' do
    it 'must return an enumerator' do
      @chapter.each.must_be_instance_of Enumerator
    end

    it 'must iterate through each page' do
      count = 0
      @chapter.each do |page|
        page.must_be_instance_of Mangdown::Page
        count += 1 
      end
      count.must_equal @chapter.pages.length
    end
  end

  describe 'download_to' do
    before do
      # @times will start at 0 and end at N, where N is the number 
      # of specs in this describe block 
      @times ||= 0
      @chapter.download_to(download_path) if @times == 0
      @times += 1
    end

    after do
      # @times will start at 0 and end at N, where N is the number 
      # of specs in this describe block 
      if @times == 2 && Dir.exist?("#{download_path}/#{chapter_name}")
        FileUtils.rm_r(@nisekoi_dir, force: true)
      end
    end

    it 'must create a subdirectory with the chapter name' do
      Dir.exist?("#{download_path}/#{download_chapter_name}").must_equal true
    end

    it 'must have page files in the sub directory' do
      files = Dir["#{download_path}/#{chapter_name}/*"]
      files.each do |name|
        @chapter.pages.any? { |page| name =~ /#{page.name}/ }
          .must_equal true
      end
    end
  end
end
