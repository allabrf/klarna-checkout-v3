# frozen_string_literal: true

module Klarna
  module Checkout
    module Operations
      module Refund
        def refund_order(amount = nil)
          response = execute_refund_request(amount)

          unless response.status == 201
            raise Klarna::Checkout::Errors::OrderRefundError.new(@status, 'refund_not_allowed')
          end

          @status = 'REFUNDED'
          response
        end

        private

        def execute_refund_request(amount)
          https_connection.post do |req|
            req.url "/ordermanagement/v1/orders/#{@reference}/refunds"
            req.options.timeout = 10

            req.headers['Authorization'] = authorization
            req.headers['Content-Type']  = 'application/json'
            req.body = {
              'refunded_amount': amount.nil? ? @klarna_response['order_amount'] : amount,
              'order_lines': @items
            }.to_json
          end
        end
      end
    end
  end
end
