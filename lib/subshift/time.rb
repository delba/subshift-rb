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
