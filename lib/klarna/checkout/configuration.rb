# frozen_string_literal: true

module Klarna
  module Checkout
    class Configuration
      attr_accessor :purchase_country, :purchase_currency, :locale, :terms_uri, :checkout_uri, :confirmation_uri, :push_uri, :environment, :user_id, :passcode

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
        raise Klarna::Checkout::Errors::ConfigurationError.new('purchase_country', 'missing_configuration_item') unless @purchase_country

        @purchase_country
      end

      def purchase_currency
        raise Klarna::Checkout::Errors::ConfigurationError.new('purchase_currency', 'missing_configuration_item') unless @purchase_currency

        @purchase_currency
      end

      def locale
        raise Klarna::Checkout::Errors::ConfigurationError.new('locale', 'missing_configuration_item') unless @locale

        @locale
      end

      def terms_uri
        raise Klarna::Checkout::Errors::ConfigurationError.new('terms_uri', 'missing_configuration_item') unless @terms_uri

        @terms_uri
      end

      def checkout_uri
        raise Klarna::Checkout::Errors::ConfigurationError.new('checkout_uri', 'missing_configuration_item') unless @checkout_uri

        @checkout_uri
      end

      def confirmation_uri
        raise Klarna::Checkout::Errors::ConfigurationError.new('confirmation_uri', 'missing_configuration_item') unless @confirmation_uri

        @confirmation_uri
      end

      def push_uri
        raise Klarna::Checkout::Errors::ConfigurationError.new('push_uri', 'missing_configuration_item') unless @push_uri

        @push_uri
      end

      def environment
        raise Klarna::Checkout::Errors::ConfigurationError.new('environment', 'missing_configuration_item') unless @environment

        @environment
      end

      def user_id
        raise Klarna::Checkout::Errors::ConfigurationError.new('user_id', 'missing_configuration_item') unless @user_id

        @user_id
      end

      def passcode
        raise Klarna::Checkout::Errors::ConfigurationError.new('passcode', 'missing_configuration_item') unless @passcode

        @passcode
      end

      def checkout_url
        raise Klarna::Checkout::Errors::ConfigurationError.new('checkout_url', 'missing_configuration_item') unless @checkout_url

        @checkout_url
      end
    end
  end
end
