require 'test_helper'

class RunnerTest < Minitest::Test
  def setup
    @runner = Subshift::Runner.new(['sample.srt', '0'])
  end

  def teardown
    if File.exist?('sample_delayed.srt')
      FileUtils.rm('sample_delayed.srt')
    end
  end

  def test_delegators
    runner = Subshift::Runner.new(['sample.srt', '3'])
    options = runner.options

    assert_equal options.source, runner.source
    assert_equal options.delay, runner.delay
    assert_equal options.destination, runner.destination
  end

  def test_run
    regexp = Subshift::Time::FORMAT

    assert_equal '00:00:42,407', regexp.match(File.read('sample.srt'))[0]
    Subshift::Runner.run(['sample.srt', '3'])
    assert_equal '00:00:45,407', regexp.match(File.read('sample.srt'))[0]

    # Reset
    Subshift::Runner.run(['sample.srt', '-3'])

    assert_equal '00:00:42,407', regexp.match(File.read('sample.srt'))[0]
    Subshift::Runner.run(['sample.srt', '3', '-d', 'sample_delayed.srt'])
    assert_equal '00:00:45,407', regexp.match(File.read('sample_delayed.srt'))[0]
  end

  def test_timeline
    refute @runner.send(:timeline?, '1')
    assert @runner.send(:timeline?, '00:00:42,407 --> 00:00:44,932')
    refute @runner.send(:timeline?, '<i>"Winner, winner, chicken dinner."</i>')
  end

  def test_shift_times
    set_delay(2)
    assert_equal '00:00:44,407 --> 00:00:46,932', @runner.send(:shift_times, '00:00:42,407 --> 00:00:44,932')

    set_delay(-2)
    assert_equal '00:00:40,407 --> 00:00:42,932', @runner.send(:shift_times, '00:00:42,407 --> 00:00:44,932')

    set_delay(2.5)
    assert_equal '00:00:44,907 --> 00:00:47,432', @runner.send(:shift_times, '00:00:42,407 --> 00:00:44,932')

    set_delay(-2.5)
    assert_equal '00:00:39,907 --> 00:00:42,432', @runner.send(:shift_times, '00:00:42,407 --> 00:00:44,932')
  end

private

  def set_delay(seconds)
    @runner.options.instance_variable_set :@delay, seconds
  end
end
