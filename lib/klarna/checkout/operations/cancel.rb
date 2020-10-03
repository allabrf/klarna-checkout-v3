# frozen_string_literal: true

module Klarna
  module Checkout
    module Operations
      module Cancel
        def cancel_order
          response = https_connection.post do |req|
            req.url "/ordermanagement/v1/orders/#{@reference}/cancel"
            req.options.timeout = 10

            req.headers['Authorization'] = authorization
            req.headers['Content-Type']  = 'application/json'
          end

          unless response.status == 204
            raise Klarna::Checkout::Errors::OrderCancelError.new(@status, 'cancel_not_allowed')
          end

          @status = 'CANCELLED'
          response
        end
      end
    end
  end
end
