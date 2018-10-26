require 'stringio'
require 'test_helper'

module Mangdown
  class ChapterTest < Minitest::Test
    def test_adapter
      TestAdapter.new(:uri, :doc, :name)
    end

    def setup
      @chapter = Chapter.new('uri', 'name', 'manga', 1)
      @chapter.adapter = test_adapter
    end

    def test_new
      @chapter.adapter = 'adapter'

      assert_equal 'uri', @chapter.uri
      assert_equal 'name', @chapter.name
      assert_equal [], @chapter.pages
      assert_equal 1, @chapter.chapter
      assert_equal 'adapter', @chapter.adapter
    end

    def test_cbz
      CBZ.class_eval do
        class << self
          alias old_one one
          def one(path)
            path
          end
        end
      end

      @chapter.instance_variable_set(:@path, 'path')

      assert_equal 'path', @chapter.cbz

      CBZ.class_eval do
        class << self
          alias one old_one
        end
      end
    end

    def test_to_chapter
      assert_equal @chapter, @chapter.to_chapter
    end

    def test_to_path
      assert_equal(
        "#{Mangdown::DOWNLOAD_DIR}/manga/name", @chapter.to_path.to_s
      )
    end

    def test_setup_path
      @chapter.setup_path(Dir.pwd)
      assert_equal "#{Dir.pwd}/name", @chapter.to_path.to_s
    end

    def test_load_pages
      Tools.class_eval do
        class << self
          alias old_hydra_streaming hydra_streaming

          def hydra_streaming(objects, *other_args)
            objects.map do |obj|
              next unless yield(:before, obj)
              yield(:succeeded, obj)
              yield(:body, obj, 'data')
              yield(:complete, obj)
            end
          end
        end
      end

      @chapter.load_pages

      refute_empty @chapter.pages

      Tools.class_eval do
        class << self
          alias hydra_streaming old_hydra_streaming
        end
      end
    end

    def test_each
      @chapter.pages.concat(Array.new(10, {}))

      assert_equal @chapter.pages.length, @chapter.each.count

      @chapter.each.with_index do |page, i|
        assert_equal @chapter.pages[i].object_id, page.object_id
      end
    end

    def test_download_to
      skip
    end
  end
end

