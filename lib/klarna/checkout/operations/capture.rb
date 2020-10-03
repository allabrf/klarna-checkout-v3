# frozen_string_literal: true

module Klarna
  module Checkout
    module Operations
      module Capture
        def capture_order(amount = nil)
          response = execute_capture_request(amount)

          unless response.status == 201
            raise Klarna::Checkout::Errors::OrderCaptureError.new(@status, 'capture_not_allowed')
          end

          @status = 'CAPTURED'
          response
        end

        private

        def execute_capture_request(amount)
          https_connection.post do |req|
            req.url "/ordermanagement/v1/orders/#{@reference}/captures"
            req.options.timeout = 10

            req.headers['Authorization'] = authorization
            req.headers['Content-Type']  = 'application/json'

            req.body = {
              'captured_amount': amount.nil? ? @klarna_response['order_amount'] : amount,
              'order_lines': @items
            }.to_json
          end
        end
      end
    end
  end
end
