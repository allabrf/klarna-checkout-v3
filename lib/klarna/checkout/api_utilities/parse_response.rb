# frozen_string_literal: true

module Klarna
  module Checkout
    module ApiUtilities
      module ParseResponse
        def parse_response(data)
          @klarna_response = OpenStruct.new(JSON.parse(data))
          @payment_form    = @klarna_response.html_snippet
          @reference       = @klarna_response.order_id
          @status          = @klarna_response.status
        end
      end
    end
  end
end
