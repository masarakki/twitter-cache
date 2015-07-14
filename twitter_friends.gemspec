# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twitter_friends/version'

Gem::Specification.new do |spec|
  spec.name          = 'twitter_friends'
  spec.version       = TwitterFriends::VERSION
  spec.authors       = ['masarakki']
  spec.email         = ['masaki@hisme.net']

  spec.summary       = 'easy access and cache twitter friends'
  spec.description   = 'easy access and cache twitter friends'
  spec.homepage      = 'https://github.com/masarakki/twitter_friends'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  %w(rspec rubocop guard guard-rspec guard-rubocop rspec-its activemodel coveralls webmock pry dotenv).each do |gem|
    spec.add_development_dependency gem
  end

  %w(twitter redis-namespace oj).each do |gem|
    spec.add_dependency gem
  end
end
