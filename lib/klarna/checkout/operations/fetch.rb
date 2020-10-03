# frozen_string_literal: true

module Klarna
  module Checkout
    module Operations
      module Fetch
        include Klarna::Checkout::ApiUtilities::ConnectionUtilities
        PATH_CHECKOUT  = '/checkout/v3/orders/'
        PATH_CONFIRMED = '/ordermanagement/v1/orders/'

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
          response = execute_fetch_request(path, ref)
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

          build_order(order_header, response_body)
        end

        def execute_fetch_request(path, ref)
          https_connection.get do |req|
            req.url "#{path}#{ref}"
            req.options.timeout = 10

            req.headers['Authorization'] = authorization
            req.headers['Content-Type']  = 'application/json'
          end
        end

        def build_order(header, body)
          order = Klarna::Checkout::Order.new(
            header: header,
            items: body['order_lines']
          )

          order.status = body['status']
          order.reference = body['order_id']
          order.klarna_response = body
          order.recurring = (body['recurring'] == true)

          order
        end
      end
    end
  end
end
