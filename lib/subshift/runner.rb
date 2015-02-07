module Subshift
  class Runner
    attr_reader :options

    delegate :source, :destination, :delay, to: :options

    def self.run(argv)
      new(argv).run
    end

    def initialize(argv)
      @options = Options.new(argv)
    end

    def run
      File.copylines(source, destination) do |line|
        timeline?(line) ? shift_times(line) : line
      end
    end

  private

    def shift_times(line)
      line.gsub(Time::FORMAT) do |time|
        Time.parse(time) + delay
      end
    end

    def timeline?(line)
      /-->/ === line
    end
  end
end
