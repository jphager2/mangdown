# frozen_string_literal: true

require 'stringio'
require 'test_helper'

module Mangdown
  class ChapterTest < Minitest::Test
    attr_reader :adapter, :chapter
    def setup
      register_test_adapter
      @adapter = TestAdapter::Chapter.new(url: 'uri', name: 'name', number: 1)
      @adapter.manga = TestAdapter::Manga.new(url: 'url', name: 'manga')
      @chapter = Chapter.new(adapter)
    end

    def test_new
      assert_equal 'uri', chapter.uri
      assert_equal 'name', chapter.name
      assert_equal [], chapter.pages
      assert_equal 1, chapter.number
    end

    def test_cbz
      chapter.instance_variable_set(:@path, 'path')

      with_stubbed_cbz do
        assert_equal %w[cbz_called path], chapter.cbz
      end
    end

    def test_to_path
      assert_equal(chapter.manga.name, 'manga')
      assert_equal(
        "#{Mangdown::DOWNLOAD_DIR}/manga/name", chapter.to_path.to_s
      )
    end

    def test_setup_path
      chapter.setup_path(Dir.pwd)
      assert_equal "#{Dir.pwd}/name", chapter.to_path.to_s
    end

    def test_download_to
      skip
    end
  end
end
