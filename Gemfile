# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in klarna.gemspec
gemspec

group :development, :test do
  gem 'pry'
  gem 'pry-byebug'
  gem 'rake', '< 14.0'
  gem 'rspec', '< 4.0'
  gem 'rubocop', '~> 1.86.0', require: false
end

group :test do
  gem 'vcr', '< 7.0'
  gem 'webmock', '< 4.0'
end
