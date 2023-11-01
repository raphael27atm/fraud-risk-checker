# spec/helpers/json_web_token_spec.rb

require 'rails_helper'

RSpec.describe JsonWebToken do
  let(:payload) { { user_id: 1 } }
  let(:token) { described_class.encode(payload) }

  describe '.encode' do
    it 'encodes a payload into a JWT token' do
      expect(token).not_to be_nil
      expect(token).to be_a(String)
    end
  end

  describe '.decode' do
    context 'with a valid token' do
      it 'decodes a JWT token back to its original payload' do
        expect(described_class.decode(token)).to include(
          "user_id" => 1
        )
      end
    end

    context 'with an invalid token' do
      let(:invalid_token) { 'invalid_token' }

      it 'raises a decode error' do
        expect { described_class.decode(invalid_token) }.to raise_error(JWT::DecodeError)
      end
    end
  end
end
