require 'test_helper'

class Engine
  attr_reader :power

  def initialize(power)
    @power = power
  end
end

class Car
  attr_reader :engine

  delegate :power, to: :engine

  def initialize
    @engine = Engine.new(123)
  end
end

class TestModule < Minitest::Test
  def test_delegate
    car = Car.new
    assert_equal 123, car.power
  end
end
