# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'serial_fetcher/version'

Gem::Specification.new do |spec|
  spec.name          = "serial_fetcher"
  spec.version       = SerialFetcher::VERSION
  spec.authors       = ["o-bo"]

  spec.summary       = %q{A script to ease fetching data from hash params in ruby applications.}
  spec.description   = %q{Serial Fetcher provides a way to automatically fetch a list of resources from the params hash. The params must be passed to the `fetch` method with a `schema` describing the associations between params and models. A fetcher must be provided to the SerialFetcher through configuration. By default there is an ActiveRecord fetcher that call `find` to the constantized class name.}
  spec.homepage      = "https://github.com/o-bo/serial_fetcher"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
