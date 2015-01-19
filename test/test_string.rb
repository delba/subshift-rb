require 'test_helper'

class TestString < Minitest::Test
  def test_timeline
    refute '1'.timeline?
    assert '00:00:42,407 --> 00:00:44,932'.timeline?
    refute '<i>"Winner, winner, chicken dinner."</i>'.timeline?
  end

  def test_shift_times
    assert_equal '00:00:44,407 --> 00:00:46,932', '00:00:42,407 --> 00:00:44,932'.shift_times(2)
    assert_equal '00:00:40,407 --> 00:00:42,932', '00:00:42,407 --> 00:00:44,932'.shift_times(-2)
    assert_equal '00:00:44,907 --> 00:00:47,432', '00:00:42,407 --> 00:00:44,932'.shift_times(2.5)
    assert_equal '00:00:39,907 --> 00:00:42,432', '00:00:42,407 --> 00:00:44,932'.shift_times(-2.5)
  end
end
