require 'forwardable'

module Extensions
  module Module
    def self.prepended(base)
      base.include Forwardable
    end

    def delegate(*methods, to:)
      super methods => to
    end
  end
end

Module.prepend Extensions::Module
