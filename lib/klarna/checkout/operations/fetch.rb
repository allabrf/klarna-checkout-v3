# frozen_string_literal: true

module Klarna
  module Checkout
    module Operations
      module Fetch
        include Klarna::Checkout::ApiUtilities::ConnectionUtilities
        PATH_CHECKOUT  = '/checkout/v3/orders/'.freeze
        PATH_CONFIRMED = '/ordermanagement/v1/orders/'.freeze

        # To fetch order during checkout stage
        def fetch_checkout_order(ref)
          fetch_order(PATH_CHECKOUT, ref)
        end

        # To fetch order after checkout stage
        def fetch_confirmed_order(ref)
          fetch_order(PATH_CONFIRMED, ref)
        end

        private

        def fetch_order(path, ref)
          response = https_connection.get do |req|
            req.url "#{path}#{ref}"
            req.options.timeout = 10

            req.headers['Authorization'] = authorization
            req.headers['Content-Type']  = 'application/json'
          end

          # Raise error if order is not found
          unless response.status == 200
            raise Klarna::Checkout::Errors::OrderNotFoundError.new("Unable to fetch order: #{ref}", 'order_not_found')
          end

          response_body = JSON.parse(response.body)
          order_header  = {
                            purchase_country: response_body['purchase_country'],
                            purchase_currency: response_body['purchase_currency'],
                            locale: response_body['locale'],
                            order_amount: response_body['order_amount'],
                            order_tax_amount: response_body['order_tax_amount']
                          }

          order = Klarna::Checkout::Order.new(header: order_header, items: response_body['order_lines'])
          order.status          = response_body['status']
          order.reference       = response_body['order_id']
          order.klarna_response = response_body
          order.recurring       = true if response_body['recurring']

          order
        end
      end
    end
  end
end
