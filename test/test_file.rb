require 'test_helper'

class TestFile < Minitest::Test
  def setup
    File.open 'file', 'w' do |f|
      f.puts '1'
      f.puts '2'
      f.puts '3'
    end
  end

  def teardown
    FileUtils.rm 'file'

    if File.exist? 'copy'
      FileUtils.rm 'copy'
    end
  end

  def test_copylines
    File.copylines 'file', 'copy' do |line|
      "First line\n" if /1/ === line
    end

    assert_equal "First line\n2\n3\n", File.read('copy')
  end

  def test_copylines_on_the_same_file
    File.copylines 'file', 'file' do |line|
      "First line\n" if /1/ === line
    end

    assert_equal "First line\n2\n3\n", File.read('file')
  end
end
