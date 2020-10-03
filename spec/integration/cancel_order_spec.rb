# frozen_string_literal: true

require 'spec_helper'
require 'support/vcr_setup'

RSpec.describe 'cancel order', :vcr do
  context 'with a valid reference' do
    let(:ref) { 'c14727be-cb29-6cbc-acd7-f269797ca88c' }
    let(:order) { Klarna::Checkout::Order.find(ref) }

    before do
      order.cancel
    end

    it 'has an updated status' do
      expect(order.status).to eql 'CANCELLED'
    end
  end

  context 'order has been captured' do
    let(:ref) { 'da5d42c9-411d-6534-820a-d3213ec43a66' }
    let(:order) { Klarna::Checkout::Order.find(ref) }

    it 'raises error' do
      expect { order.cancel }.to raise_error(Klarna::Checkout::Errors::OrderCancelError)
    end
  end
end
