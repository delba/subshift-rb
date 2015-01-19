require 'optparse'

module Subshift
  class Options
    attr_reader :source, :delay, :destination

    def initialize(argv)
      parse(argv)

      self.source, self.delay = argv

      unless destination
        self.destination = source
      end
    end

  private

    def source=(source)
      unless source
        puts option_parser.help
        exit
      end

      @source = normalize_filename(source)

      unless File.exist? @source
        puts "Error: The file #{@source} doesn't exist"
        exit
      end
    end

    def delay=(delay)
      unless delay
        puts option_parser.help
        exit
      end

      @delay = delay.to_f
    end

    def destination=(destination)
      @destination = normalize_filename(destination)
    end

    def parse(argv)
      begin
        option_parser.parse(argv)
      rescue OptionParser::InvalidOption => e
        if /[[:digit:]]/ === e.args[0]
          option_parser.parse(argv - e.args)
        else
          raise OptionParser::InvalidOption.new(*e.args)
        end
      end
    end

    def option_parser
      @option_parser ||= OptionParser.new do |opts|
        executable_name = File.basename($PROGRAM_NAME, '.rb')
        opts.banner = "A simple yet robust SRT Resync Tool

        Usage: #{executable_name} SOURCE DELAY [options]"

        opts.separator 'Options:'

        opts.on '-d DESTINATION', '--destination DESTINATION', 'Destination file' do |destination|
          send :destination=, destination
        end

        opts.on_tail '-h', '--help', 'Show this message' do
          puts opts
          exit
        end
      end
    end

    def normalize_filename(filename)
      File.basename(filename, '.*') + '.srt'
    end
  end
end
