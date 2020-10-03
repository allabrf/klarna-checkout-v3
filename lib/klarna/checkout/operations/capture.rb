# frozen_string_literal: true

module Klarna
  module Checkout
    module Operations
      module Capture
        def capture_order(amount = nil)
          capture_amount = amount.nil? ? @klarna_response['order_amount'] : amount

          payload = {
            'captured_amount': capture_amount,
            'order_lines': @items
          }.to_json

          request = https_connection.post do |req|
            req.url "/ordermanagement/v1/orders/#{@reference}/captures"
            req.options.timeout = 10

            req.headers['Authorization'] = authorization
            req.headers['Content-Type']  = 'application/json'
            req.body = payload
          end

          if request.status == 201
            @status = 'CAPTURED'
          else
            raise Klarna::Checkout::Errors::OrderCaptureError.new(@status, 'capture_not_allowed')
          end

          request
        end
      end
    end
  end
end
