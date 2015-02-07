require 'test_helper'

class RunnerTest < Minitest::Test
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
    regexp = String::TIME

    assert_equal '00:00:42,407', regexp.match(File.read('sample.srt'))[0]
    Subshift::Runner.run(['sample.srt', '3'])
    assert_equal '00:00:45,407', regexp.match(File.read('sample.srt'))[0]

    # Reset
    Subshift::Runner.run(['sample.srt', '-3'])

    assert_equal '00:00:42,407', regexp.match(File.read('sample.srt'))[0]
    Subshift::Runner.run(['sample.srt', '3', '-d', 'sample_delayed.srt'])
    assert_equal '00:00:45,407', regexp.match(File.read('sample_delayed.srt'))[0]
  end
end
