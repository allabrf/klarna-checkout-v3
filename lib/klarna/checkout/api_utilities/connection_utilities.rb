# frozen_string_literal: true

module Klarna
  module Checkout
    module ApiUtilities
      module ConnectionUtilities
        KLARNA_SANDBOX_URL    = 'https://api.playground.klarna.com'.freeze
        KLARNA_PRODUCTION_URL = 'https://api.klarna.com'.freeze

        def host
          return KLARNA_PRODUCTION_URL if Klarna::Checkout.configuration.environment == 'production'

          KLARNA_SANDBOX_URL
        end

        def https_connection
          @https_connection ||= Faraday.new(url: host)
        end
      end
    end
  end
end
