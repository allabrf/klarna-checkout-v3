# frozen_string_literal: true

require_relative 'lib/klarna/checkout/version'

Gem::Specification.new do |spec|
  spec.name          = 'klarna-checkout'
  spec.version       = Klarna::Checkout::VERSION
  spec.authors       = ['Sverrir Steindorsson', 'Mike Eyrikh']
  spec.email         = ['sverrir.steindorsson@allabrf.se']

  spec.summary       = 'A Ruby wrapper for the Klarna Checkout API.'
  spec.description   = 'The gem provides methods to fetch, create, capture, cancel and refund Klarna orders.'
  spec.homepage      = 'https://www.rubygems.org/gems/klarna-checkout'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://gitlab.com/allabrf/klarna-checkout-v3'
  spec.metadata['changelog_uri'] = 'https://gitlab.com/allabrf/klarna-checkout-v3/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday'

  spec.add_development_dependency 'pry', '~> 0.13.1'
  spec.add_development_dependency 'rspec', '~> 3.2'
end
