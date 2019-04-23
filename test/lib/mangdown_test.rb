# frozen_string_literal: true

require 'test_helper'

class MangdownTest < Minitest::Test
  def setup
    register_test_adapter
  end

  def test_register_adapter
    adapters_before = Mangdown.adapters.length

    bogus = Object.new

    Mangdown.register_adapter(:bogus_adapter, bogus)

    assert_equal adapters_before + 1, Mangdown.adapters.length
  ensure
    Mangdown.adapters.delete(:bogus_adapter)
  end

  def test_manga_with_url
    Mangdown.manga('uri')

    assert_equal 1, test_adapter.manga_called
  end

  def test_chapter_with_url
    Mangdown.chapter('uri')

    assert_equal 1, test_adapter.chapter_called
  end

  def test_page_with_url
    Mangdown.page('uri')

    assert_equal 1, test_adapter.page_called
  end

  def test_manga_with_instance
    Mangdown.manga(TestAdapter::Manga.new)

    assert_nil test_adapter.manga_called
  end

  def test_chapter_with_instance
    Mangdown.chapter(TestAdapter::Chapter.new)

    assert_nil test_adapter.chapter_called
  end

  def test_page_with_instance
    Mangdown.page(TestAdapter::Page.new)

    assert_nil test_adapter.page_called
  end
end
