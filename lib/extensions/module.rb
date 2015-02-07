require 'forwardable'

module Extensions
  module Module
    def self.prepended(base)
      base.include Forwardable
    end

    def delegate(*methods, to:)
      public_send :def_delegators, to, *methods
    end
  end
end

Module.prepend Extensions::Module
