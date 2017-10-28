require 'test_helper'

class MangdownTest < Minitest::Test

  def doc
    Nokogiri::HTML("<html></html>")
  end

  def test_register_adapter
    adapters_before = Mangdown::ADAPTERS.length

    bogus = Class.new(Mangdown::Adapter::Base)

    Mangdown.register_adapter(:bogus_adapter, bogus)

    assert Mangdown::ADAPTERS.length == adapters_before + 1

    Mangdown::ADAPTERS.delete(:bogus_adapter)
  end

  def test_adapter
    assert_equal TestAdapter, Mangdown.adapter(:test)
    assert_equal TestAdapter, Mangdown.adapter(:test)
  end

  def test_adapter!
    assert_instance_of Mangdown::Adapter::Proxy, Mangdown.adapter!("test")

    assert_instance_of TestAdapter, Mangdown.adapter!("test").adapter
    assert_instance_of TestAdapter, Mangdown.adapter!(nil, "test").adapter
    assert_instance_of TestAdapter, Mangdown.adapter!(
      "test", nil, doc, "test"
    ).adapter

    adapters = Mangdown::ADAPTERS.dup
    Mangdown::ADAPTERS.clear

    assert_raises(Mangdown::Adapter::NoAdapterError) { 
      Mangdown.adapter!(nil) 
    }

    Mangdown::ADAPTERS.merge!(adapters)
  end
end
