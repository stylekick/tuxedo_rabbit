# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tuxedo_rabbit/version'

Gem::Specification.new do |spec|
  spec.name          = "tuxedo_rabbit"
  spec.version       = TuxedoRabbit::VERSION
  spec.authors       = ["Anand"]
  spec.email         = ["anand180@gmail.com"]
  spec.summary       = %q{Dressed Up RabbitMQ for Rails}
  spec.description   = %q{Robust RabbitMQ messaging with Redis failover}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = ['tuxedo']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "redis", "~> 3.0"
  spec.add_dependency "hutch", "~> 0.8"
  spec.add_dependency "activemodel", "~> 4.0"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14.1"
  spec.add_development_dependency "rspec-fire", "~> 1.2"

end
