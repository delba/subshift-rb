require_relative 'test_helper'

class TestEncoding < Minitest::Test
  def test_default_external
    assert_equal Encoding.find('ISO-8859-1'), Encoding.default_external
  end
end
