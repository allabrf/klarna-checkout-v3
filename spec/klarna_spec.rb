# frozen_string_literal: true

RSpec.describe Klarna do
  it 'has a version number' do
    expect(Klarna::Checkout::VERSION).not_to be nil
  end
end
