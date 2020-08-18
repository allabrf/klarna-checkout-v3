module Klarna
  module Checkout
    module Operations
      module Cancel
        def cancel_order
          request = https_connection.post do |req|
            req.url "/ordermanagement/v1/orders/#{@reference}/cancel"
            req.options.timeout = 10

            req.headers['Authorization'] = authorization
            req.headers['Content-Type']  = 'application/json'
          end

          if request.status == 204
            @status = 'CANCELLED'
          else
            raise Klarna::Checkout::Errors::OrderCancelError.new(@status, 'cancel_not_allowed')
          end
        end
      end
    end
  end
end
