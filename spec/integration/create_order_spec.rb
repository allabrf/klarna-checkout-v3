# frozen_string_literal: true

require 'spec_helper'
require 'support/vcr_setup'

RSpec.describe 'create order', :vcr do
  let(:header) {
    {
      order_amount: 9900,
      order_tax_amount: 1980
    }
  }

  let(:items) {
    [
      {
        type: 'digital',
        reference: '11111',
        name: 'Funny Service',
        quantity: 1,
        unit_price: 9900,
        tax_rate: 2500,
        total_amount: 9900,
        total_discount_amount: 0,
        total_tax_amount: 1980
      }
    ]
  }

  let(:checkout_url) { 'http://example.com/checkout' }

  context 'with required parameters' do
    let(:order) { Klarna::Checkout::Order.new(header: header, items: items, checkout_url: checkout_url) }

    before do
      order.execute
    end

    it 'contains a html_snippet object' do
      expect(order.payment_form).to include('<div id="klarna-checkout-container" ')
    end

    it 'contains an order_id' do
      expect(order.reference).to_not be_nil
    end

    it 'contains an order status' do
      expect(order.status).to eql 'checkout_incomplete'
    end

    it 'contains required header fields' do
      expect(order.klarna_response.purchase_country).to eql 'se'
      expect(order.klarna_response.purchase_currency).to eql 'SEK'
      expect(order.klarna_response.locale).to eql 'sv-SE'
      expect(order.klarna_response.order_amount).to eql 9900
      expect(order.klarna_response.order_tax_amount).to eql 1980
    end

    it 'contains required item fields' do
      expect(order.klarna_response.order_lines.first.keys).to contain_exactly('type', 'reference', 'name', 'quantity', 'unit_price', 'tax_rate', 'total_amount', 'total_discount_amount', 'total_tax_amount')
    end
  end

  context 'with required parameters missing' do
    let(:order) { Klarna::Checkout::Order.new(header: header, items: items, checkout_url: checkout_url) }

    describe 'missing header fields' do
      let(:header) {
        {
          purchase_country: 'SE'
        }
      }

      it 'raises error' do
        expect{ order.execute }.to raise_error(Klarna::Checkout::Errors::OrderValidationError)
      end
    end

    describe 'missing item fields' do
      let(:items) {
        [
          {
            type: 'digital'
          }
        ]
      }

      it 'raises error' do
        expect{ order.execute }.to raise_error(Klarna::Checkout::Errors::OrderValidationError)
      end
    end
  end

  context 'amount validations' do
    describe 'order_amount does not match sum of total_amounts' do
      let(:header) {
        {
          order_amount: 7900,
          order_tax_amount: 1980
        }
      }
      let(:order) { Klarna::Checkout::Order.new(header: header, items: items, checkout_url: checkout_url) }

      it 'raises error' do
        expect{ order.execute }.to raise_error(Klarna::Checkout::Errors::OrderValidationError)
      end
    end

    describe 'order_tax_amount does not match sum of total_tax_amounts' do
      let(:header) {
        {
          order_amount: 7900,
          order_tax_amount: 1980
        }
      }
      let(:order) { Klarna::Checkout::Order.new(header: header, items: items, checkout_url: checkout_url) }

      it 'raises error' do
        expect{ order.execute }.to raise_error(Klarna::Checkout::Errors::OrderValidationError)
      end
    end

    describe 'total_amounts do not match quantity times unit_price' do
      let(:header) {
        {
          order_amount: 9900,
          order_tax_amount: 1980
        }
      }

      let(:items) {
        [
          {
            type: 'digital',
            reference: '11111',
            name: 'Funny Service',
            quantity: 1,
            unit_price: 9900,
            tax_rate: 2500,
            total_amount: 9800,
            total_discount_amount: 0,
            total_tax_amount: 1980
          }
        ]
      }
      let(:order) { Klarna::Checkout::Order.new(header: header, items: items, checkout_url: checkout_url) }

      it 'raises error' do
        expect{ order.execute }.to raise_error(Klarna::Checkout::Errors::OrderValidationError)
      end
    end

    describe 'incorrect total_tax_amounts calculation' do
      let(:header) {
        {
          order_amount: 9900,
          order_tax_amount: 1980
        }
      }

      let(:items) {
        [
          {
            type: 'digital',
            reference: '11111',
            name: 'Funny Service',
            quantity: 1,
            unit_price: 9900,
            tax_rate: 2500,
            total_amount: 9900,
            total_discount_amount: 0,
            total_tax_amount: 1280
          }
        ]
      }
      let(:order) { Klarna::Checkout::Order.new(header: header, items: items, checkout_url: checkout_url) }

      it 'raises error' do
        expect{ order.execute }.to raise_error(Klarna::Checkout::Errors::OrderValidationError)
      end
    end
  end
end

