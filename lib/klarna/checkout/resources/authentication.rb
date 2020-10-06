# frozen_string_literal: true

module Klarna
  module Checkout
    module Resources
      module Authentication
        def authorization
          uid  = Klarna::Checkout.configuration.user_id
          pass = Klarna::Checkout.configuration.passcode

          encode_base64(uid, pass)
        end

        private

        def encode_base64(username, password)
          ['Basic', Base64.encode64("#{username}:#{password}").chomp].join(' ')
        end
      end
    end
  end
end
