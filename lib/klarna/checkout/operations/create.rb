module Klarna
  module Checkout
    module Operations
      module Create
        CREATE_ORDER_PATH = '/checkout/v3/orders/'.freeze

        def create(header, items)
          payload = header.merge({
            order_lines: items,
            merchant_urls: merchant_urls
          })

          payload.merge!({recurring: true}) if @recurring
          payload.merge!({customer: @customer}) if @customer
          @api_order = payload

          parse_response(
            request(payload.to_json)
          )
        end

        private

        def request(payload)
          https_connection.post do |req|
            req.url CREATE_ORDER_PATH
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
