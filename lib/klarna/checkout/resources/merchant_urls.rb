# frozen_string_literal: true

module Klarna
  module Checkout
    module Resources
      module MerchantUrls
        def merchant_urls
          {
            push: Klarna::Checkout.configuration.push_uri,
            terms: @terms_url,
            confirmation: Klarna::Checkout.configuration.confirmation_uri,
            checkout: @checkout_url
          }
        end
      end
    end
  end
end
