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

Subshift::Runner.run!(ARGV)
```

```ruby
module Subshift
  class Runner
    # ...

    def run!
      File.copylines(source, destination) do |line|
        line.timeline? ? line.shift_times(delay) : line
      end
    end
  end
end
```

```ruby
require 'time'

class String
  TIME = /\d{2}:\d{2}:\d{2},\d{3}/

  def shift_times(delay)
    gsub(TIME) do |time|
      new_time = Time.parse(time) + delay
      new_time.strftime '%H:%M:%S,%3N'
    end
  end

  def timeline?
    /-->/ === self
  end
end
```

```ruby
require 'tempfile'

class File
  def self.copylines(src, dst)
    tempfile = Tempfile.new(dst)

    begin
      readlines(src).each do |line|
        line = yield(line) if block_given?

        tempfile.write line
      end

      FileUtils.chmod(stat(src).mode, tempfile.path)
      FileUtils.move(tempfile.path, dst)
    ensure
      tempfile.close!
    end
  end
end
```

## Contributing

1. Fork it ( https://github.com/delba/subshift/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
