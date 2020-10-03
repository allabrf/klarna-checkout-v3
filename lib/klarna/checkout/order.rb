# frozen_string_literal: true

module Klarna
  module Checkout
    class Order
      extend Klarna::Checkout::ApiUtilities::ParseResponse
      extend Klarna::Checkout::Operations::Acknowledge
      extend Klarna::Checkout::Operations::Fetch
      extend Klarna::Checkout::Operations::CreateRecurring
      extend Klarna::Checkout::Resources::Authentication

      include Klarna::Checkout::ApiUtilities::ConnectionUtilities
      include Klarna::Checkout::ApiUtilities::ParseResponse
      include Klarna::Checkout::Validations::OrderValidations
      include Klarna::Checkout::Operations::Create
      include Klarna::Checkout::Operations::Capture
      include Klarna::Checkout::Operations::Cancel
      include Klarna::Checkout::Operations::Refund
      include Klarna::Checkout::Resources::Authentication
      include Klarna::Checkout::Resources::MerchantUrls

      attr_accessor :status, :payment_form, :reference, :api_order, :klarna_response, :recurring

      def self.acknowledge(ref)
        acknowledge_order(ref)
      end

      # For creating an order, using a recurring_token
      def self.create_recurring(**args)
        if args[:recurring_token].nil?
          raise Klarna::Checkout::Errors::OrderValidationError.new('Argument missing', 'missing_recurring_token')
        end

        create_recurring_order(args)
      end

      # Returns an instance of the order
      def self.find(ref)
        fetch_confirmed_order(ref)
      end

      # Same as find but to be used during checkout stage
      def self.find_checkout(ref)
        fetch_checkout_order(ref)
      end

      def initialize(header:, items:, recurring: false, customer: nil, checkout_url: nil)
        @header    = header
        @items     = items
        @recurring = recurring
        @customer  = customer
        @checkout_url = checkout_url.nil? ? Klarna::Checkout.configuration.checkout_uri : checkout_url
      end

      # Creates an order
      # Returns prepolulated order object based on Klarna API response
      def execute
        add_defaults
        validate
        create(@header, @items)
      end

      #
      # Existing order methods
      #

      #
      # Captures the order through Klarna API
      def capture
        unless @status == 'AUTHORIZED'
          raise Klarna::Checkout::Errors::OrderCaptureError.new(@status, 'capture_not_allowed')
        end

        capture_order
      end

      # Cancels the order through Klarna API
      def cancel
        unless @status == 'AUTHORIZED'
          raise Klarna::Checkout::Errors::OrderCancelError.new(@status, 'cancel_not_allowed')
        end

        cancel_order
      end

      # Refunds the order through Klarna API
      def refund
        raise Klarna::Checkout::Errors::OrderRefundError.new(@status, 'refund_not_allowed') unless @status == 'CAPTURED'

        refund_order
      end

      private

      def add_defaults
        @header.merge!(
          {
            purchase_country: Klarna::Checkout.configuration.purchase_country,
            purchase_currency: Klarna::Checkout.configuration.purchase_currency,
            locale: Klarna::Checkout.configuration.locale
          }
        )
      end

      def validate
        header_keys_existance
        item_keys_existance

        amount_validation
        tax_amount_validation
        total_amount_validation
        total_tax_amount_validation
      end
    end
  end
end
