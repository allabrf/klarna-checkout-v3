# frozen_string_literal: true

module Klarna
  module Checkout
    module Validations
      module OrderValidations
        REQUIRED_ORDER_KEYS = %i[purchase_country purchase_currency locale order_amount order_tax_amount].freeze
        REQUIRED_ITEM_KEYS  = %i[type name quantity unit_price tax_rate total_amount total_tax_amount].freeze

        def header_keys_existance
          missing_keys = REQUIRED_ORDER_KEYS - @header.keys
          return true if missing_keys.empty?

          raise Klarna::Checkout::Errors::OrderValidationError.new(missing_keys, 'missing_order_keys')
        end

        def item_keys_existance
          @items.map(&:keys).each do |item_keys|
            missing_keys = REQUIRED_ITEM_KEYS - item_keys

            unless missing_keys.empty?
              raise Klarna::Checkout::Errors::OrderValidationError.new(missing_keys, 'missing_item_keys')
            end
          end

          true
        end

        # 1. order_amount == sum of all items total_amounts
        def amount_validation
          return if @items.map { |i| i[:total_amount].to_i }.sum == @header[:order_amount].to_i

          raise Klarna::Checkout::Errors::OrderValidationError.new(
            'inconsistent_values', 'order_amount_not_matching_total_amounts'
          )
        end

        # 2. order_tax_amount == sum of all items total_tax_amounts
        def tax_amount_validation
          return if @items.map { |i| i[:total_tax_amount].to_i }.sum == @header[:order_tax_amount].to_i

          raise Klarna::Checkout::Errors::OrderValidationError.new(
            'inconsistent_values', 'total_tax_amount_not_matching_total_tax_amounts'
          )
        end

        # 3. [loop through all items] -> unit_price * quantity == total_amount
        def total_amount_validation
          @items.each do |i|
            next if i[:quantity].to_i * (i[:unit_price].to_i - i[:total_discount_amount].to_i) == i[:total_amount].to_i

            raise Klarna::Checkout::Errors::OrderValidationError.new(
              'inconsistent_order_line_totals', 'total_line_amount_not_matching_qty_times_unit_price'
            )
          end
        end

        # 4. [loop through all items] -> total_tax_amount / (total_amount - total_tax_amount) == tax_rate * 10_000
        def total_tax_amount_validation
          @items.each do |i|
            next if i[:total_tax_amount].to_i * 100 / (i[:total_amount].to_i - i[:total_tax_amount].to_i) == i[:tax_rate].to_i / 100

            raise Klarna::Checkout::Errors::OrderValidationError.new(
              'inconsistent_order_line_total_tax', 'line_total_tax_amount_not_matching_tax_rate'
            )
          end
        end
      end
    end
  end
end
