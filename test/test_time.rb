require 'test_helper'

class TestTime < Minitest::Test
  def test_parse
    time = Subshift::Time.parse('00:00:00,000')
    assert_equal 0, time.total_ms
  end

  def test_plus
    time = Subshift::Time.parse('00:00:00,000') + 1
    assert_equal 1000, time.total_ms
  end

  def test_to
    time = Subshift::Time.parse('12:34:56,789')
    assert_equal '12:34:56,789', time.send(:to_s)
  end
end
