# frozen_string_literal: true

module Klarna
  module Checkout
    module Errors
      class OrderNotFoundError < StandardError
        def initialize(message, exception_type)
          @exception_type = exception_type
          super(message)
        end
      end
    end
  end
end
