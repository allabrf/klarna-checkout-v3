# frozen_string_literal: true

require 'spec_helper'
require 'support/vcr_setup'

RSpec.describe 'capture order', :vcr do
  context 'with a valid reference' do
    let(:ref)   { 'fe558eb2-9124-6c73-8291-b1d449d5d44c' }
    let(:order) { Klarna::Checkout::Order.find(ref) }

    before do
      order.capture
    end

    it 'has an updated status' do
      expect(order.status).to eql 'CAPTURED'
    end
  end

  context 'order status not applicable' do
    let(:ref)   { '52061f5f-4f30-68b7-9294-ad42ee512918' }
    let(:order) { Klarna::Checkout::Order.find(ref) }

    it 'raises error' do
      expect{ order.capture }.to raise_error(Klarna::Checkout::Errors::OrderCaptureError)
    end
  end
end
