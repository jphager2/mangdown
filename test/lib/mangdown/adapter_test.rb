require "test_helper"

module Mangdown
  class AdapterTest < Minitest::Test

    def bogus_adapter(&block)
      Class.new(Mangdown::Adapter::Base, &block)
    end

    def test_adapter
      TestAdapter.new(:uri, :doc, :name)
    end

    def test_public_api
      class_methods = %w{ for? site }
      instance_methods = %w{ uri name doc site is_manga_list? is_manga? is_chapter? is_page? manga_list manga chapter_list chapter page_list page }

      adapter = bogus_adapter
      class_methods.each do |method|
        assert adapter.respond_to?(method, false)
      end

      instance = adapter.new(:uri, :doc, :name)
      instance_methods.each do |method|
        assert instance.respond_to?(method, false)
      end
    end

    def test_set_site
      adapter = bogus_adapter do
        site "test site"
      end

      assert_equal "test site", adapter.site
    end

    # Test the test adapter?
    def test_for_accepts_anything
      assert TestAdapter.for?(:anything)
    end

    def test_methods_that_always_respond_true
      adapter = test_adapter

      assert adapter.is_manga_list?
      assert adapter.is_manga?
      assert adapter.is_chapter?
      assert adapter.is_page?

      assert adapter.is_manga_list?(:anything)
      assert adapter.is_manga?(:anything)
      assert adapter.is_chapter?(:anything)
      assert adapter.is_page?(:anything)
    end

    def test_manga_list_returns_array_of_hashes
      adapter = test_adapter

      list = adapter.manga_list

      assert_respond_to list, :to_ary
      assert_respond_to list.first, :to_hash
      assert_equal [:uri, :name, :site].sort, list.first.keys.sort
    end

    def test_manga_returns_a_hash
      adapter = test_adapter

      manga = adapter.manga

      assert_respond_to manga, :to_hash
      assert_equal [:uri, :name, :site].sort, manga.keys.sort
    end

    def test_chapter_list_returns_array_of_hashes
      adapter = test_adapter

      list = adapter.chapter_list

      assert_respond_to list, :to_ary
      assert_respond_to list.first, :to_hash
      assert_equal [:uri, :name, :site].sort, list.first.keys.sort
    end

    def test_chapter_returns_a_hash
      adapter = test_adapter

      chapter = adapter.chapter
      keys = [:uri, :name, :site, :manga, :chapter].sort

      assert_respond_to chapter, :to_hash
      assert_equal keys, chapter.keys.sort
    end

    def test_page_list_returns_array_of_hashes
      adapter = test_adapter

      list = adapter.page_list

      assert_respond_to list, :to_ary
      assert_respond_to list.first, :to_hash
      assert_equal [:uri, :name, :site].sort, list.first.keys.sort
    end

    def test_page_returns_a_hash
      adapter = test_adapter

      page = adapter.page

      assert_respond_to page, :to_hash
      assert_equal [:uri, :name, :site].sort, page.keys.sort
    end

    def test_doc
      assert_equal :doc, test_adapter.doc
    end
  end
end
