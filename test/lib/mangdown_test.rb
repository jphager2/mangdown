require_relative '../test_helper'

class MangdownTest < Minitest::Test

  def doc
    Nokogiri::HTML("<html></html>")
  end

  def test_register_adapter
    adapters_before = Mangdown::ADAPTERS.length

    bogus = Class.new(Mangdown::Adapter::Base)

    Mangdown.register_adapter(:bogus_adapter, bogus)

    assert Mangdown::ADAPTERS.length == adapters_before + 1
  end

  def test_adapter
    assert_equal TestAdapter, Mangdown.adapter(:test)
  end

  def test_adapter!
    assert_instance_of TestAdapter, Mangdown.adapter!("test")
    assert_instance_of TestAdapter, Mangdown.adapter!(nil, "test")
    assert_instance_of TestAdapter, Mangdown.adapter!(
      "test", nil, doc, "test")

    assert_raises(Mangdown::Adapter::NoAdapterError) { 
      Mangdown.adapter!(nil) 
    }
  end
end
