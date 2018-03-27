# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version_hook'

Gem::Specification.new do |spec|
  spec.name          = 'mumuki-gobstones-runner'
  spec.version       = GobstonesVersionHook::VERSION
  spec.authors       = ['Rodrigo Alfonso']
  spec.email         = ['rodri042@gmail.com']
  spec.summary       = 'Gobstones Runner for Mumuki'
  spec.homepage      = 'http://github.com/gobstones/mumuki-gobstones-runner'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/**']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'mumukit', '~> 2.20'
  spec.add_dependency 'sinatra-cross_origin', '~> 0.4'
  spec.add_dependency 'gobstones-board', '~>1.14'
  spec.add_dependency 'gobstones-blockly', '~>0.10'
  spec.add_dependency 'gobstones-code-runner', '~>0.0'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'mumukit-bridge', '~> 3.0'
end
