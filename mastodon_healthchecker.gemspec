# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mastodon_healthchecker/version'

Gem::Specification.new do |spec|
  spec.name          = 'mastodon_healthchecker'
  spec.version       = MastodonHealthchecker::VERSION
  spec.authors       = ['nullkal']
  spec.email         = ['nullkal@nil.nu']

  spec.summary       = 'Perform the health check of a mastodon instance'
  spec.description   = <<-DESCRIPTION
mastodon_healthchecker provides a function which checks the connectability,
and other statuses of a mastodon instance.
  DESCRIPTION
  spec.homepage      = 'https://github.com/nullkal/mastodon_healthchecker'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.49.1'

  spec.add_runtime_dependency 'faraday', '~> 0.9.2'
  spec.add_runtime_dependency 'faraday-encoding', '~> 0.0.4'
  spec.add_runtime_dependency 'faraday_middleware', '~> 0.10.0'
  spec.add_runtime_dependency 'oj', '~> 3.3'
  spec.add_runtime_dependency 'nokogiri', '~> 1.6', '>= 1.6.7.2'
end
