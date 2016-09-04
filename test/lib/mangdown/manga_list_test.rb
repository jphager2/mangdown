require "test_helper"

module Mangdown
  class MangaListTest < Minitest::Test
    def setup
      hashes = Array.new(5, { uri: '' })
      @list = MangaList.new(hashes)
    end

    def test_manga_list_manga
      assert_equal 5, @list.manga.length
      assert @list.manga.all? { |manga| manga.is_a?(MDHash) }
    end

    def test_each
      count = 0
      @list.manga.each do |manga|
        count += 1
        assert manga.is_a?(MDHash)
      end
    end

    def test_to_yaml
      yaml = @list.to_yaml
      hashes = YAML.load(yaml)

      assert_equal 5, hashes.length
      assert hashes.all? { |hash| hash.is_a?(Hash) }
    end

    def test_load_manga
      count = @list.manga.length
      @list.load_manga('uri')

      assert @list.manga.length > count
      assert @list.manga.all? { |manga| manga.is_a?(MDHash) }
    end

    def test_array_conversions
      assert_equal @list.to_a, @list.to_ary
      assert_equal @list.manga, @list.to_a
    end

    def test_merge
      assert_equal @list.to_a.length * 2, @list.merge(@list).to_a.length
      assert_instance_of MangaList, @list.merge(MangaList.new)
      assert @list.manga.all? { |manga| manga.is_a?(MDHash) }
    end
  end
end
