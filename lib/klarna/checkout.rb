# Gem dependencies
require 'faraday'
require 'json'
require 'set'

# Gem version
require 'klarna/checkout/version'

# Configuration
require 'klarna/checkout/configuration'

# Utilities
require 'klarna/checkout/api_utilities/connection_utilities.rb'
require 'klarna/checkout/api_utilities/parse_response'

# Errors
require 'klarna/checkout/errors/order_validation_error.rb'
require 'klarna/checkout/errors/order_capture_error.rb'
require 'klarna/checkout/errors/order_cancel_error.rb'
require 'klarna/checkout/errors/order_refund_error.rb'
require 'klarna/checkout/errors/configuration_error.rb'
require 'klarna/checkout/errors/order_not_found_error.rb'

# Operations
require 'klarna/checkout/operations/acknowledge.rb'
require 'klarna/checkout/operations/capture.rb'
require 'klarna/checkout/operations/cancel.rb'
require 'klarna/checkout/operations/create.rb'
require 'klarna/checkout/operations/fetch.rb'
require 'klarna/checkout/operations/refund.rb'
require 'klarna/checkout/operations/create_recurring.rb'

# Resources
require 'klarna/checkout/resources/authentication.rb'
require 'klarna/checkout/resources/merchant_urls.rb'

# The order class
require 'klarna/checkout/order.rb'

# For configuration
module Klarna
  module Checkout
    class << self
      attr_accessor :configuration

      def configuration
        @@configuration ||= Klarna::Checkout::Configuration.new
      end

      def configure
        yield(configuration)
      end
    end
  end
end
