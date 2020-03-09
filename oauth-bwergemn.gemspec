# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oauth_bwergemn/version'

Gem::Specification.new do |spec|
  spec.name    = 'oauth-bwergemn'
  spec.version = OauthBwergemn::VERSION
  spec.authors = ['Alam Ybs']
  spec.email   = ['namakukingkong@gmail.com']

  spec.summary     = 'Oauth Bwergemn is a Grape middleware for your API authenticator'
  spec.description = 'Oauth Bwergemn is a Grape middleware to connect your API resources with your API authenticator.'
  spec.homepage    = 'https://github.com/namakukingkong/oauth-bwergemn'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org/'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.1.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rack', '~> 2.0.8'
  spec.add_development_dependency 'rspec', '~> 3.7.0'
  spec.add_development_dependency 'rubocop', '~> 0.79.0'
  spec.add_development_dependency 'rubocop-performance', '~> 1.5.2'
  spec.add_dependency 'grape', '~> 1.2.0'
end
