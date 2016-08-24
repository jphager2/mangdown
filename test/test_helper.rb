require 'minitest/autorun'
require 'minitest/pride'

require 'mangdown'

require_relative 'support/test_adapter'

Mangdown.register_adapter(:test, TestAdapter)
