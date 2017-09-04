# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clockwork_mocks/version'

Gem::Specification.new do |spec|
  spec.name          = 'clockwork-mocks'
  spec.version       = ClockworkMocks::VERSION
  spec.authors       = ['David Poetzsch-Heffter']
  spec.email         = ['davidpoetzsch@web.de']

  spec.summary       = 'Helpers for manual scheduling of clockwork tasks for integration testing'
  spec.description   = 'clockwork provides a cron-like utility for ruby. ' \
    'This gem adds the possibility to create integration tests for these tasks'
  spec.homepage      = 'https://github.com/dpoetzsch/clockwork-mocks'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'clockwork', '~> 2.0'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'timecop'
end
