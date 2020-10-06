# frozen_string_literal: true

require 'spec_helper'
require 'support/vcr_setup'

RSpec.describe 'create a recurring order', :vcr do
  let(:header) do
    {
      purchase_country: 'SE',
      purchase_currency: 'SEK',
      locale: 'sv-SE',
      order_amount: 9900,
      order_tax_amount: 1980
    }
  end

  let(:items) do
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
  end

  let(:checkout_url) { 'http://example.com/checkout' }

  context 'with recurring argument' do
    let(:order) do
      Klarna::Checkout::Order.new(header: header,
                                  items: items,
                                  recurring: true,
                                  checkout_url: checkout_url)
    end

    before do
      order.execute
    end

    it 'has recurring attribute set to true' do
      expect(order.recurring).to be_truthy
    end

    it 'contains a recurring field in body' do
      expect(order.klarna_response.recurring).to be_truthy
    end
  end

  context 'without recurring argument' do
    let(:order) { Klarna::Checkout::Order.new(header: header, items: items, checkout_url: checkout_url) }

    before do
      order.execute
    end

    it 'has recurring attribute set to true' do
      expect(order.recurring).to be_falsey
    end

    it 'does not contain a recurring field in body' do
      expect(order.klarna_response.recurring).to be_nil
    end
  end

  context 'when total_discount_amount is not subtracted from total_amount' do
    let(:bad_items) do
      [
        {
          type: 'digital',
          reference: '11111',
          name: 'Funny Service',
          quantity: 1,
          unit_price: 9900,
          tax_rate: 2500,
          total_amount: 9900,
          total_discount_amount: 1000,
          total_tax_amount: 1980
        }
      ]
    end

    let(:order) do
      Klarna::Checkout::Order.new(header: header,
                                  items: bad_items,
                                  recurring: true,
                                  checkout_url: checkout_url)
    end

    it 'raises error' do
      expect { order.execute }.to raise_error(Klarna::Checkout::Errors::OrderValidationError)
    end
  end
end
