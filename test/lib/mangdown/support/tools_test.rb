require 'test_helper'
require 'webmock/minitest'

module Mangdown
  class ToolsTest < Minitest::Test
    UriStruct = Struct.new(:uri)

    def test_get_doc
      url = 'http://www.anything.com/'
      stub_request(:get, url).to_return(body: '<html><body>Body</body>')

      doc = Tools.get_doc(url)
      assert_equal 'Body', doc.css('body').text
    end

    def test_get
      url = 'http://www.anything.com/'
      stub_request(:get, url).to_return(body: 'Body')

      body = Tools.get(url)
      assert_equal 'Body', body
    end

    def test_get_root
      url_with_path = 'http://www.anything.com/path/to/something'
      url_with_slash = 'http://www.anything.com/'
      url = 'http://www.anything.com'
      
      assert_equal url, Tools.get_root(url)
      assert_equal url, Tools.get_root(url_with_slash)
      assert_equal url, Tools.get_root(url_with_path)
    end

    def test_relative_or_absolute_path
      absolute = %w(/root to this path)
      relative = %w(relative path from here)

      absolute_path = Tools.relative_or_absolute_path(*absolute)
      relative_path = Tools.relative_or_absolute_path(*relative)

      assert_equal '/root/to/this/path', absolute_path.to_s
      assert_equal Dir.pwd + '/relative/path/from/here', relative_path.to_s
    end

    def test_valid_path_name
      assert_equal 'Name 00001.ext', Tools.valid_path_name('Name 001.ext')
      assert_equal 'Name 00001', Tools.valid_path_name('Name 001')
      assert_equal 'Name 00001', Tools.valid_path_name('Name 1')
      assert_equal 'Name 00001', Tools.valid_path_name('Name 00000000001')
      assert_equal '100 Name', Tools.valid_path_name('100 Name')
      assert_equal 'Name 100 Name', Tools.valid_path_name('Name 100 Name')
      assert_equal 'Name', Tools.valid_path_name('Name')
      assert_equal(
        'Name 10000000000', Tools.valid_path_name('Name 10000000000')
      )
      assert_equal(
        '/path/to/Name 00001', Tools.valid_path_name('/path/to/Name 001')
      )
    end

    def test_file_type
      image_dir = Pathname.new(
        File.expand_path('../../../fixtures/images', __dir__)
      )

      assert_equal 'jpeg', Tools.image_extension(image_dir.join('naruto.jpg'))
      assert_equal 'png', Tools.image_extension(image_dir.join('naruto.png'))
      assert_equal 'gif', Tools.image_extension(image_dir.join('naruto.gif'))
    end

    def test_hydra_streaming
      objects = 3.times.map do |i|
        url = "http://www.anything-#{i}.com/"
        stub_request(:get, url).to_return(
          body: "<html><body>Body-#{i}</body>"
        )
        UriStruct.new(url)
      end

      url = 'http://www.fail.com/'
      objects << UriStruct.new(url)
      stub_request(:get, url).to_return(status: 404)

      bodies = []
      fails = []
      complete = []
      
      Tools.hydra_streaming(objects) do |status, object, data=nil|
        case status
        when :before
          return true unless objects.index(object) == 1
        when :succeeded
          # Do nothing
        when :failed
          fails << object
        when :complete
          complete << object
        when :body
          bodies << data
        end
      end

      assert_equal ['Body-0', 'Body-2'], bodies.sort
      assert_equal [objects.delete(3)], fails
      refute_includes complete, objects.delete(1)
      assert_equal objects, complete
    end
  end
end
