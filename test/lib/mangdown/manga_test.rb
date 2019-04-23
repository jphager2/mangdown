# frozen_string_literal: true

require 'stringio'
require 'test_helper'

module Mangdown
  class MangaTest < Minitest::Test
    attr_reader :adapter, :manga

    def setup
      register_test_adapter
      @adapter = TestAdapter::Manga.new(url: 'uri', name: 'name')
      @manga = Manga.new(adapter)
    end

    def test_new
      assert_equal 'uri', manga.uri
      assert_equal 'name', manga.name
      assert_equal [], manga.chapters
    end

    def test_cbz
      manga.instance_variable_set(:@path, 'path')

      with_stubbed_cbz do
        assert_equal %w[cbz_called path], manga.cbz
      end
    end

    def test_to_path
      assert_equal "#{Mangdown::DOWNLOAD_DIR}/name", manga.to_path.to_s
    end

    def test_setup_path
      manga.setup_path(Dir.pwd)
      assert_equal "#{Dir.pwd}/name", manga.to_path.to_s
    end

    def test_download_to
      skip
    end
  end
end
