# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'subshift/version'

Gem::Specification.new do |spec|
  spec.name          = "subshift"
  spec.version       = Subshift::VERSION
  spec.authors       = ["delba"]
  spec.email         = ["delba@users.noreply.github.com"]
  spec.summary       = %q{A simple yet robust SRT resync tool}
  spec.homepage      = "https://github.com/delba/subshift"
  spec.license       = "MIT"

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^test/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.required_ruby_version = "~> 2.1"
end
