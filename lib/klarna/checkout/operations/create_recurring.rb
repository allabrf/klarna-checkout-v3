# frozen_string_literal: true

module Klarna
  module Checkout
    module Operations
      module CreateRecurring
        def create_recurring_order(**args)
          # args is to contain: [{order_lines}], order_amount, order_tax_amount, purchase_currency, locale, recurring_token
          payload = {
            'locale':            args[:locale],
            'order_lines':       args[:order_lines],
            'order_amount':      args[:order_amount],
            'order_tax_amount':  args[:order_tax_amount],
            'purchase_currency': args[:purchase_currency],
            'auto_capture':      true,
          }

          JSON.parse(request(payload.to_json, args[:recurring_token]))
        end

        private

        def request(payload, recurring_token)
          https_connection.post do |req|
            req.url "/customer-token/v1/tokens/#{recurring_token}/order"
            req.options.timeout = 10

            req.headers['Authorization'] = authorization
            req.headers['Content-Type']  = 'application/json'
            req.body = payload
          end.body
        end
      end
    end
  end
end
