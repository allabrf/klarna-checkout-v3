# frozen_string_literal: true

module Klarna
  module Checkout
    class Configuration
      attr_writer :purchase_country,
                  :purchase_currency,
                  :locale,
                  :terms_uri,
                  :checkout_uri,
                  :confirmation_uri,
                  :push_uri,
                  :environment,
                  :user_id,
                  :passcode

      def initialize
        @purchase_country  = nil
        @purchase_currency = nil
        @locale            = nil
        @terms_uri         = nil
        @checkout_uri      = nil
        @confirmation_uri  = nil
        @push_uri          = nil
        @environment       = nil
        @user_id           = nil
        @passcode          = nil
        @checkout_url      = nil
      end

      def purchase_country
        unless @purchase_country
          raise Klarna::Checkout::Errors::ConfigurationError.new('purchase_country', 'missing_configuration_item')
        end

        @purchase_country
      end

      def purchase_currency
        unless @purchase_currency
          raise Klarna::Checkout::Errors::ConfigurationError.new('purchase_currency', 'missing_configuration_item')
        end

        @purchase_currency
      end

      def locale
        raise Klarna::Checkout::Errors::ConfigurationError.new('locale', 'missing_configuration_item') unless @locale

        @locale
      end

      def terms_uri
        unless @terms_uri
          raise Klarna::Checkout::Errors::ConfigurationError.new('terms_uri', 'missing_configuration_item')
        end

        @terms_uri
      end

      def checkout_uri
        unless @checkout_uri
          raise Klarna::Checkout::Errors::ConfigurationError.new('checkout_uri', 'missing_configuration_item')
        end

        @checkout_uri
      end

      def confirmation_uri
        unless @confirmation_uri
          raise Klarna::Checkout::Errors::ConfigurationError.new('confirmation_uri', 'missing_configuration_item')
        end

        @confirmation_uri
      end

      def push_uri
        unless @push_uri
          raise Klarna::Checkout::Errors::ConfigurationError.new('push_uri', 'missing_configuration_item')
        end

        @push_uri
      end

      def environment
        unless @environment
          raise Klarna::Checkout::Errors::ConfigurationError.new('environment', 'missing_configuration_item')
        end

        @environment
      end

      def user_id
        raise Klarna::Checkout::Errors::ConfigurationError.new('user_id', 'missing_configuration_item') unless @user_id

        @user_id
      end

      def passcode
        unless @passcode
          raise Klarna::Checkout::Errors::ConfigurationError.new('passcode', 'missing_configuration_item')
        end

        @passcode
      end

      def checkout_url
        unless @checkout_url
          raise Klarna::Checkout::Errors::ConfigurationError.new('checkout_url', 'missing_configuration_item')
        end

        @checkout_url
      end
    end
  end
end
