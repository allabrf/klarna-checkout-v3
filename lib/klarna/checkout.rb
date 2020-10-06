# frozen_string_literal: true

# Gem dependencies
require 'faraday'
require 'json'
require 'set'

# Gem version
require 'klarna/checkout/version'

# Configuration
require 'klarna/checkout/configuration'

# Utilities
require 'klarna/checkout/api_utilities/connection_utilities'
require 'klarna/checkout/api_utilities/parse_response'

# Errors
require 'klarna/checkout/errors/order_validation_error'
require 'klarna/checkout/errors/order_capture_error'
require 'klarna/checkout/errors/order_cancel_error'
require 'klarna/checkout/errors/order_refund_error'
require 'klarna/checkout/errors/configuration_error'
require 'klarna/checkout/errors/order_not_found_error'

# Operations
require 'klarna/checkout/operations/acknowledge'
require 'klarna/checkout/operations/capture'
require 'klarna/checkout/operations/cancel'
require 'klarna/checkout/operations/create'
require 'klarna/checkout/operations/fetch'
require 'klarna/checkout/operations/refund'
require 'klarna/checkout/operations/create_recurring'

# Resources
require 'klarna/checkout/resources/authentication'
require 'klarna/checkout/resources/merchant_urls'

# Order validations
require 'klarna/checkout/validations/order_validations'

# The order class
require 'klarna/checkout/order'

# For configuration
module Klarna
  module Checkout
    class << self
      attr_writer :configuration

      def configuration
        @configuration ||= Klarna::Checkout::Configuration.new
      end

      def configure
        yield(configuration)
      end
    end
  end
end
