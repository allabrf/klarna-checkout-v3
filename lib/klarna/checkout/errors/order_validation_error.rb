module Klarna
  module Checkout
    module Errors
      class OrderValidationError < StandardError
        def initialize(message, exception_type)
          @exception_type = exception_type
          super(message)
        end
      end
    end
  end
end
