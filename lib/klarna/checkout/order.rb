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
      end

      def header_keys_existance
        missing_keys = REQUIRED_ORDER_KEYS - @header.keys
        return true if missing_keys.empty?

        raise Klarna::Checkout::Errors::OrderValidationError.new(missing_keys, 'missing_order_keys')
      end

      def item_keys_existance
        @items.map(&:keys).each do |item_keys|
          missing_keys = REQUIRED_ITEM_KEYS - item_keys

          if !missing_keys.empty?
            raise Klarna::Checkout::Errors::OrderValidationError.new(missing_keys, 'missing_item_keys')
          end
        end

        true
      end

      def amount_validation
        # 1. order_amount == sum of all items total_amounts
        unless @items.map { |i| i[:total_amount] }.sum == @header[:order_amount]
          raise Klarna::Checkout::Errors::OrderValidationError.new('inconsistent_values', 'order_amount_not_matching_total_amounts')
        end

        # 2. order_tax_amount == sum of all items total_tax_amounts
        unless @items.map { |i| i[:total_tax_amount] }.sum == @header[:order_tax_amount]
          raise Klarna::Checkout::Errors::OrderValidationError.new('inconsistent_values', 'total_tax_amount_not_matching_total_tax_amounts')
        end

        # 3. [loop through all items] -> (unit_price - discount) * quantity == total_amount
        @items.each do |i|
          unless i[:quantity] * (i[:unit_price] - i[:total_discount_amount].to_i) == i[:total_amount]
            raise Klarna::Checkout::Errors::OrderValidationError.new('inconsistent_order_line_totals', 'total_line_amount_not_matching_qty_times_unit_price')
          end
        end

        # 4. [loop through all items] -> total_tax_amount / (total_amount - total_tax_amount) == tax_rate * 10_000
        @items.each do |i|
          unless i[:total_tax_amount].to_f / (i[:total_amount] - i[:total_tax_amount]) == i[:tax_rate] / 10_000.0
            raise Klarna::Checkout::Errors::OrderValidationError.new('inconsistent_order_line_total_tax', 'line_total_tax_amount_not_matching_tax_rate')
          end
        end
      end
    end
  end
end
