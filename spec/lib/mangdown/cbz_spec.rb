require_relative '../../spec_helper'

describe Mangdown::CBZ do
  describe 'CBZ all' do

    before do
      @fixtures_dir = File.expand_path('../../../fixtures', __FILE__)
      @tmp_dir      = File.expand_path('../../../../tmp', __FILE__)
      @nisekoi_dir  = @tmp_dir + "/Nisekoi"
      FileUtils.cp_r(@fixtures_dir + '/Nisekoi', @tmp_dir) 
      Mangdown::CBZ.all(@nisekoi_dir)
    end

    after do
      FileUtils.rm_r(@nisekoi_dir, force: true)
    end

    it 'must have equal numbers of cbz files and chapter directories' do
      chapter_count = Dir["#{@nisekoi_dir}/*/"].length
      cbz_count     = Dir["#{@nisekoi_dir}/*.cbz"].length
      cbz_count.must_equal(chapter_count)
    end

    it 'cbz file names should be valid' do
      filenames = Dir["#{@nisekoi_dir}/*.cbz"]
      filenames.each do |name|
        name.must_match /\d{3}\.cbz/
      end
    end

    it 'cbz image file names should be valid' do
      zips = Dir["#{@nisekoi_dir}/*.cbz"]
      names = zips.flat_map {|f| Zip::File.new(f).glob('*').map(&:name)}
      names.each do |name|
        # Don't use #must_match, it causes an error with Zip::File
        (name =~ /Page \d{3}/).wont_be_nil
      end
    end
  end
end
