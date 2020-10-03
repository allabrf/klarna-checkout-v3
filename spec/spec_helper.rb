# frozen_string_literal: true

require "bundler/setup"
require "klarna/checkout"
require "pry"
require "pry-byebug"
require 'vcr'
require 'webmock/rspec'

# WebMock.disable_net_connect!(allow_localhost: true)
WebMock.allow_net_connect!

RSpec.configure do |config|

  config.before(:all) do
    Klarna::Checkout.configure do |config|
      config.purchase_country  = 'se'
      config.purchase_currency = 'SEK'
      config.locale            = 'se-SE'
      config.terms_uri         = 'http://www.example.com/terms'
      config.checkout_uri      = 'http://www.example.com/checkout'
      config.confirmation_uri  = 'http://www.example.com/confirmation_uri'
      config.push_uri          = 'http://www.example.com/push'
      config.environment       = 'test'
      config.user_id           = 'the_dude'
      config.passcode          = 'abides'
    end
  end

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
