# Subshift

A simple yet robust SRT resync tool

## Installation

    $ gem install subshift

## Usage

- Add 2 seconds to `subtitles.srt`

```bash
$ subshift subtitles 2
```

- Remove 2.5 seconds from `subtitles.srt` and save the result
  in `delayed_subtitles.srt`

```bash
$ subshift subtitles.srt -2.5 -d delayed_subtitles.srt
```

- Display the help

```bash
$ subshift --help
```

## The Gist

`Subshift` is a standalone program, not intended to be "puristic" but fun, and makes an extensive use of monkey-patching.
Here are some extracts from it:

```bin
#!/usr/bin/env ruby

require 'subshift'

Subshift::Runner.run(ARGV)
```

```ruby
module Subshift
  class Runner
    # ...

    def run
      File.copylines(source, destination) do |line|
        shift_times(line) if timeline?(line)
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
```

```ruby
require 'singleton'

module Subshift
  class Time
    include Singleton

    FORMAT = /\d{2,}:\d{2}:\d{2},\d{3}/

    attr_accessor :total_ms

    def self.parse(string)
      h, m, s, ms = string.split(/:|,/).map(&:to_i)

      instance.total_ms = \
        h * 60 * 60 * 1000 +
        m * 60 * 1000 +
        s * 1000 +
        ms

      instance
    end

    def +(seconds)
      tap do |t|
        t.total_ms += seconds * 1000
      end
    end

  private

    def to_s
      h, ms = total_ms.divmod(60 * 60 * 1000)
      m, ms = ms.divmod(60 * 1000)
      s, ms = ms.divmod(1000)

      format '%02d:%02d:%02d,%03d', h, m, s, ms
    end
  end
end
```

```ruby
require 'tempfile'

module Extensions
  module File
    def copylines(src, dst)
      tempfile = Tempfile.new(dst)

      begin
        open(src).each_line do |line|
          if block_given?
            new_line = yield(line)
            line = new_line unless new_line.nil?
          end

          tempfile.write line
        end

        FileUtils.chmod(stat(src).mode, tempfile.path)
        FileUtils.move(tempfile.path, dst)
      ensure
        tempfile.close!
      end
    end
  end
end

File.singleton_class.prepend Extensions::File
```

## Contributing

1. Fork it ( https://github.com/delba/subshift/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
