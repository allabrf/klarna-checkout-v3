# frozen_string_literal: true

module Klarna
  module Checkout
    module Operations
      module Refund
        def refund_order(amount = nil)
          refund_amount = amount.nil? ? @klarna_response['order_amount'] : amount

          payload = {
            'refunded_amount': refund_amount,
            'order_lines': @items
          }.to_json

          request = https_connection.post do |req|
            req.url "/ordermanagement/v1/orders/#{@reference}/refunds"
            req.options.timeout = 10

            req.headers['Authorization'] = authorization
            req.headers['Content-Type']  = 'application/json'
            req.body = payload
          end

          if request.status == 201
            @status = 'REFUNDED'
          else
            raise Klarna::Checkout::Errors::OrderRefundError.new(@status, 'refund_not_allowed')
          end

          request
        end
      end
    end
  end
end
