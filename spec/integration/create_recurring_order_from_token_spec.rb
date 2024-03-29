# frozen_string_literal: true

require 'spec_helper'
require 'support/vcr_setup'

RSpec.describe 'create an order from recurring_token', :vcr do
  context 'when recurring_token is valid' do
    let(:recurring_token) { '93c69742-a378-43b7-9ae6-6d457dd4dfc6' }
    let(:locale) { 'sv-SE' }
    let(:order_amount) { 34_900 }
    let(:order_tax_amount) { 6980 }
    let(:purchase_currency) { 'SEK' }
    let(:order_lines) do
      [{
        type: 'digital',
        reference: '11111',
        name: 'The good stuff',
        quantity: 1,
        unit_price: 34_900,
        tax_rate: 2500,
        total_amount: 34_900,
        total_discount_amount: 0,
        total_tax_amount: 6980
      }]
    end

    before do
      @response = Klarna::Checkout::Order.create_recurring(
        locale: locale,
        order_lines: order_lines,
        order_amount: order_amount,
        order_tax_amount: order_tax_amount,
        purchase_currency: purchase_currency,
        recurring_token: recurring_token
      )
    end

    it 'contains an order_id in response' do
      expect(@response['order_id']).to_not be_nil
    end

    it 'contains an acceptable fraud status' do
      expect(@response['fraud_status']).to eql 'ACCEPTED'
    end

    it 'contains an authorized payment method' do
      expect(@response['authorized_payment_method']).to_not be_nil
    end
  end

  context 'when recurring_token is missing' do
    let(:locale) { 'sv-SE' }
    let(:order_amount) { 34_900 }
    let(:order_tax_amount) { 6980 }
    let(:purchase_currency) { 'SEK' }
    let(:order_lines) do
      [{
        type: 'digital',
        reference: '11111',
        name: 'The good stuff',
        quantity: 1,
        unit_price: 34_900,
        tax_rate: 2500,
        total_amount: 34_900,
        total_discount_amount: 0,
        total_tax_amount: 6980
      }]
    end

    it 'raises an error' do
      expect do
        Klarna::Checkout::Order.create_recurring(
          locale: locale,
          order_lines: order_lines,
          order_amount: order_amount,
          order_tax_amount: order_tax_amount,
          purchase_currency: purchase_currency,
          recurring_token: nil
        )
      end.to raise_error(Klarna::Checkout::Errors::OrderValidationError)
    end
  end
end
