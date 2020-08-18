module Klarna
  module Checkout
    module Operations
      module Acknowledge
        def acknowledge_order(reference)
          request = Faraday.new(host)
          request.headers['Authorization'] = authorization
          request.post("/ordermanagement/v1/orders/#{reference}/acknowledge")
        end
      end
    end
  end
end
