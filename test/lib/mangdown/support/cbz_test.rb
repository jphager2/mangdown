# frozen_string_literal: true

require 'test_helper'
require 'fileutils'

module Mangdown
  class CBZTest < Minitest::Test
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def setup
      @temp = Pathname.new(__dir__).join('tmp')
      @root_dir = @temp.join('root 1')
      @sub_dir1 = @root_dir.join('sub_dir 1')
      @sub_dir2 = @root_dir.join('sub_dir 2')

      Dir.mkdir(@temp)
      Dir.mkdir(@root_dir)
      Dir.mkdir(@sub_dir1)
      Dir.mkdir(@sub_dir2)

      (1..9).each do |i|
        filename = "file #{i}.ext"
        FileUtils.touch(@sub_dir1.join(filename))
        FileUtils.touch(@sub_dir2.join(filename))
      end
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    def teardown
      FileUtils.rm_r(@temp)
    end

    # rubocop:disable Metrics/MethodLength
    def test_all
      CBZ.all(@root_dir)

      refute File.exist?(@root_dir)

      new_root_dir = @temp.join('root 00001')

      list = Dir.new(new_root_dir).entries
      assert_includes list, 'sub_dir 00001'
      assert_includes list, 'sub_dir 00002'
      assert_includes list, 'sub_dir 00001.cbz'
      assert_includes list, 'sub_dir 00002.cbz'

      count = 0
      Zip::File.open(new_root_dir.join('sub_dir 00001.cbz')) do |zip|
        count += zip.size
      end

      assert_equal 9, count
    end
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def test_one
      CBZ.one(@sub_dir1)

      list = Dir.new(@root_dir).entries
      refute File.exist?(@sub_dir1), list.inspect
      assert File.exist?(@sub_dir2), 'Should only validate the correct dir'

      assert_includes list, 'sub_dir 00001'
      assert_includes list, 'sub_dir 00001.cbz'
      refute_includes(
        list, 'sub_dir 00002.cbz', 'Should only zip the correct dir'
      )

      count = 0
      Zip::File.open(@root_dir.join('sub_dir 00001.cbz')) do |zip|
        count += zip.size
      end

      assert_equal 9, count
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize
  end
end
