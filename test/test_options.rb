require 'test_helper'

class TestOptions < Minitest::Test
  def test_source
    options = Subshift::Options.new(['sample.srt', '3'])
    assert_equal 'sample.srt', options.source

    options = Subshift::Options.new(['sample', '3'])
    assert_equal 'sample.srt', options.source

    options = Subshift::Options.new(['sample.str', '3'])
    assert_equal 'sample.srt', options.source
  end

  def test_delay
    options = Subshift::Options.new(['sample.srt', '3'])
    assert_equal 3.0, options.delay

    options = Subshift::Options.new(['sample.srt', '3.5'])
    assert_equal 3.5, options.delay

    options = Subshift::Options.new(['sample.srt', '-3'])
    assert_equal (-3.0), options.delay

    options = Subshift::Options.new(['sample.srt', '-3.5'])
    assert_equal (-3.5), options.delay
  end

  def test_destination
    options = Subshift::Options.new(['sample.srt', '3'])
    assert_equal 'sample.srt', options.destination

    options = Subshift::Options.new(['sample.srt', '3', '-d', 'delayed.srt'])
    assert_equal 'delayed.srt', options.destination

    options = Subshift::Options.new(['sample.srt', '3', '-d', 'delayed'])
    assert_equal 'delayed.srt', options.destination

    options = Subshift::Options.new(['sample.srt', '3', '-d', 'delayed.str'])
    assert_equal 'delayed.srt', options.destination
  end
end
