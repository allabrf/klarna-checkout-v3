# frozen_string_literal: true

require 'bundler/setup'
require 'klarna/checkout'
require 'pry'
require 'pry-byebug'
require 'vcr'
require 'webmock/rspec'

# WebMock.disable_net_connect!(allow_localhost: true)
WebMock.allow_net_connect!

RSpec.configure do |config|
  config.before(:all) do
    Klarna::Checkout.configure do |c|
      c.purchase_country  = 'se'
      c.purchase_currency = 'SEK'
      c.locale            = 'se-SE'
      c.terms_uri         = 'http://www.example.com/terms'
      c.checkout_uri      = 'http://www.example.com/checkout'
      c.confirmation_uri  = 'http://www.example.com/confirmation_uri'
      c.push_uri          = 'http://www.example.com/push'
      c.environment       = 'test'
      c.user_id           = 'the_dude'
      c.passcode          = 'abides'
    end
  end

  # Allows RSpec to persist some state between runs in order to support
  # the `--only-failures` and `--next-failure` CLI options. We recommend
  # you configure your source control system to ignore this file.
  config.example_status_persistence_file_path = 'spec/tmp/examples.txt'

  # Limits the available syntax to the non-monkey patched syntax that is
  # recommended. For more details, see:
  #   - http://rspec.info/blog/2012/06/rspecs-new-expectation-syntax/
  #   - http://www.teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  #   - http://rspec.info/blog/2014/05/notable-changes-in-rspec-3/#zero-monkey-patching-mode
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
