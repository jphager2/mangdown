require "test_helper"

module Mangdown
  class MangaTest < Minitest::Test
    def test_adapter
      TestAdapter.new(:uri, :doc, :name)
    end

    def test_new
      manga = Manga.new('uri', 'name')
      manga.adapter = 'adapter'

      assert_equal 'uri', manga.uri
      assert_equal 'name', manga.name
      assert_equal [], manga.chapters
      assert_equal 'adapter', manga.adapter
    end

    def test_inspect_differs_from_object_inspect
      unbound_inspect = Object.instance_method(:inspect)
      manga = Manga.new('uri', 'name')

      refute_equal unbound_inspect.bind(manga).call(), manga.inspect
    end

    def test_to_s_differs_from_object_to_s
      unbound_to_s = Object.instance_method(:to_s)
      manga = Manga.new('uri', 'name')

      refute_equal unbound_to_s.bind(manga).call(), manga.to_s
    end

    def test_cbz
      CBZ.class_eval do
        class << self
          alias old_all all
          def all(path)
            path
          end
        end
      end

      manga = Manga.new('uri', 'name')
      manga.instance_variable_set(:@path, 'path')

      assert_equal 'path', manga.cbz

      CBZ.class_eval do
        class << self
          alias all old_all
        end
      end
    end

    def test_to_manga
      manga = Manga.new('uri', 'name')

      assert_equal manga, manga.to_manga
    end

    def test_to_path
      manga = Manga.new('uri', 'name')

      assert_equal "#{Mangdown::DOWNLOAD_DIR}/name", manga.to_path.to_s
    end

    def test_set_path
      manga = Manga.new('uri', 'name')

      manga.set_path(Dir.pwd)
      assert_equal "#{Dir.pwd}/name", manga.to_path.to_s
    end

    def test_load_chapters
      manga = Manga.new('uri', 'name')
      manga.adapter = test_adapter
      manga.load_chapters

      refute_empty manga.chapters
    end

    def test_each
      manga = Manga.new('uri', 'name')
      manga.chapters.concat(Array.new(10, {}))

      assert_equal manga.chapters.length, manga.each.count

      manga.each.with_index do |chapter, i|
        assert_equal manga.chapters[i].object_id, chapter.object_id
      end
    end

    def test_download_passes_args_to_download_to_with_nil_dir
      Manga.class_eval do
        alias old_download_to download_to

        def download_to(*args)
          args
        end
      end

      manga = Manga.new('uri', 'name')
      assert_equal [nil, 1, 2, 3], manga.download(1, 2, 3)
    end

    # TODO: Chapter#fetch_each makes http requests. Need to think of a 
    # way to handle this in testing.
    def test_download_to
      skip

      Chapter.class_eval do
        alias old_download_to download_to

        def download_to(*args)
          @counter ||= 0
          @counter += 1

          if @counter % 3 == 1
            { failed: [] }
          elsif @counter % 3 == 2
            { failed: [], skipped: [:some] }
          else
            { failed: [:some] }
          end
        end
      end

      manga = Manga.new('uri', 'name')
      manga.adapter = test_adapter
      manga.load_chapters

      result = manga.download_to(Dir.pwd)
      assert_equal 2, result[:succeded]
      assert_equal 2, result[:skipped]
      assert_equal 1, result[:failed]
    end
  end
end

