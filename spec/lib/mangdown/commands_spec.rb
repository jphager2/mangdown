require_relative '../../spec_helper'
require 'stringio'

describe M do
  before do
    VCR.insert_cassette 'events', record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'find' do
    it 'must return an array of MDHash' do
      results = M.find('Naruto')
      results.each do |result|
        result.must_be_instance_of Mangdown::MDHash
      end
    end

    it 'must only accept good search terms' do
      bad  = ['@#$$#', '........', '@#%@#$%^']
      good = ["666 Bats", "1 2 3", "Go! For! IT!"]
      bad.each  { |term| -> { M.find(term) }.must_raise ArgumentError }
      good.each { |term| -> { M.find(term) }.must_be_silent }
    end
  end

  describe 'cbz' do
    # CBZ is tested in cbz_spec.rb
    it 'must fail if given a bad path' do
      path = "super_bad_path/that/cant/possibly/exist!!!"
      -> { M.cbz(path) }.must_raise Errno::ENOENT
    end

    it 'must not fail if given a good path' do
      # Before
      fixtures_dir = File.expand_path('../../../fixtures', __FILE__)
      tmp_dir      = File.expand_path('../../../../tmp', __FILE__)
      nisekoi_dir  = tmp_dir + "/Nisekoi"
      FileUtils.cp_r(fixtures_dir + '/Nisekoi', tmp_dir) 

      -> { M.cbz(nisekoi_dir) }.must_be_silent

      # After
      FileUtils.rm_r(nisekoi_dir, force: true)
    end
  end

  describe 'help' do
    it "must output instructions for the command methods" do
      output = SpecHelper.stdout_for { M.help }
      output.length.wont_be :zero?
      ["M.help", "M.cbz", "M.clean_up"].each do |command|
        output.must_match /#{command}/ 
      end
    end
  end

  describe 'clean_up' do
    it "must delete the data file" do
      File.open(M::DATA_FILE_PATH, 'a') { |f| f.write("HELLO!") }
      M.clean_up
      File.exist?(M::DATA_FILE_PATH).must_equal false
    end
  end
end
