# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kao/version'

Gem::Specification.new do |spec|
  spec.name          = "kao"
  spec.version       = Kao::VERSION
  spec.authors       = ["motemen"]
  spec.email         = ["motemen@gmail.com"]
  spec.description   = %q{kaomoji vault}
  spec.summary       = %q{kaomoji vault}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'thor'
  spec.add_runtime_dependency 'clipboard'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
