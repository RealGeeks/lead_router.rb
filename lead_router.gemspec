# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lead_router/version'

Gem::Specification.new do |spec|
  spec.name          = "lead_router"
  spec.version       = LeadRouter::VERSION
  spec.authors       = ["Igor Sobreira"]
  spec.email         = ["igor@realgeeks.com"]

  spec.summary       = "Client to Lead Router API"
  spec.description   = "Client to Lead Router API"
  spec.homepage      = "https://github.com/realgeeks/lead_router.rb"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rest-client", "~> 1.8"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "webmock"
end