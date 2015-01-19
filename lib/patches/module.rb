require 'forwardable'

class Module
  include Forwardable

  def delegate(*methods, to:)
    public_send :def_delegators, to, *methods
  end
end
