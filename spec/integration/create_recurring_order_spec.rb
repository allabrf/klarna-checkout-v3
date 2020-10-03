# frozen_string_literal: true

require 'spec_helper'
require 'support/vcr_setup'

RSpec.describe 'create a recurring order', :vcr do
  let(:header) {
    {
      purchase_country: 'SE',
      purchase_currency: 'SEK',
      locale: 'sv-SE',
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

  context 'with recurring argument' do
    let(:order) { Klarna::Checkout::Order.new(header: header, items: items, recurring: true, checkout_url: checkout_url) }

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
end

