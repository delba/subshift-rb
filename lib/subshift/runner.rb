module Subshift
  class Runner
    attr_reader :options

    delegate :source, :destination, :delay, to: :options

    def self.run(argv)
      new(argv).run
    end

    def initialize(argv)
      @options = Subshift::Options.new(argv)
    end

    def run
      File.copylines(source, destination) do |line|
        line.timeline? ? line.shift_times(delay) : line
      end
    end
  end
end
