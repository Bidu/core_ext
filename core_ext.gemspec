# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bidu/core_ext/version'

Gem::Specification.new do |spec|
  spec.name = 'bidu-core_ext'
  spec.version = Bidu::CoreExt::VERSION
  spec.authors = ['Bidu Developers']
  spec.email = ['dev@bidu.com.br']
  spec.summary = 'Core Extensions'

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activesupport'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'rspec-mocks'
  spec.add_development_dependency 'pry-nav'
  spec.add_development_dependency 'simplecov'
end
