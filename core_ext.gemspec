# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'darthjee/core_ext/version'

Gem::Specification.new do |gem|
  gem.name                  = 'darthjee-core_ext'
  gem.version               = Darthjee::CoreExt::VERSION
  gem.authors               = ['Darthjee']
  gem.email                 = ['darthjee@gmail.com']
  gem.summary               = 'Core Extensions'
  gem.homepage              = 'https://github.com/darthjee/core_ext'
  gem.description           = 'Extension of basic classes with usefull methods'
  gem.required_ruby_version = '>= 2.4.0'

  gem.files         = `git ls-files -z`.split("\x0")
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'activesupport', '>= 5.2.x'

  gem.add_development_dependency 'bundler',       '~> 1.17.3'
  gem.add_development_dependency 'pry-nav',       '~> 0.2.4'
  gem.add_development_dependency 'rake',          '>= 12.3.1'
  gem.add_development_dependency 'rspec',         '>= 3.8'
  gem.add_development_dependency 'rubocop',       '0.58.1'
  gem.add_development_dependency 'rubocop-rspec', '1.30.0'
  gem.add_development_dependency 'rubycritic',    '>= 4.0.2'
  gem.add_development_dependency 'simplecov',     '~> 0.16.x'
  gem.add_development_dependency 'yard',          '>= 0.9.18'
  gem.add_development_dependency 'yardstick',     '>= 0.9.9'
end
