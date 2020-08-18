require 'spec_helper'
require 'support/vcr_setup'

RSpec.describe 'refund order', :vcr do
  context 'refund is successful' do
    let(:ref)   { '7ce4ee13-973c-6f49-a30e-85a0bc675997' }
    let(:order) { Klarna::Checkout::Order.find(ref) }

    it 'contains an updated status' do
      order.refund
      expect(order.status).to eql 'REFUNDED'
    end

    describe 're-fetch order from Klarna' do
      let(:order) { Klarna::Checkout::Order.find(ref) }

      it 'shows a refunded amount' do
        expect(order.klarna_response['refunded_amount']).to eql 9900
      end

      it 'has a matching order amount' do
        expect(order.klarna_response['refunded_amount']).to eql order.klarna_response['original_order_amount']
      end
    end
  end

  context 'refund not allowed' do
    let(:ref)   { '8320c1e7-8f90-6056-a62d-588b2dda6532' }
    let(:order) { Klarna::Checkout::Order.find(ref) }

    it 'raises error' do
      expect{ order.refund }.to raise_error(Klarna::Checkout::Errors::OrderRefundError)
    end
  end
end
