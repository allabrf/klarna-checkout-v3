# frozen_string_literal: true

require 'spec_helper'
require 'support/vcr_setup'

RSpec.describe 'Acknowledge order', :vcr do
  context 'checkout completed for order' do
    let(:order_ref) { 'd887e027-e135-6413-8098-2647ab04b6f0' }

    before do
      @response = Klarna::Checkout::Order.acknowledge(order_ref)
    end

    it 'responds with 204 status' do
      expect(@response.status).to eql 204
    end
  end
end
