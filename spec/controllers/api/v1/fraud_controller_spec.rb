require 'rails_helper'

RSpec.describe API::V1::FraudController, type: :controller do
  describe 'POST #check_transaction' do
    context 'with valid parameters' do
      it 'returns approve recommendation' do
        transaction_attributes = {
          transaction_id: 2342357,
          merchant_id: 29744,
          user_id: 97051,
          card_number: "434505******9116",
          transaction_date: "2019-11-31T23:16:32.812632",
          transaction_amount: 373,
          device_id: 285475
        }
        data = { data: 'secret' }
        token = JsonWebToken.encode(data)
        valid_headers = { 'Authorization' => "Bearer #{token}" }

        request.headers.merge!(valid_headers)
        post :check_transaction, params: transaction_attributes

        expect(response).to be_successful

        parsed_body = JSON.parse(response.body)

        expect(parsed_body['transaction_id']).to eq(transaction_attributes[:transaction_id])
        expect(parsed_body['recommendation']).to eq 'approve'
      end

      it 'saves the transaction to the database' do
        transaction_attributes = {
          transaction_id: 2342357,
          merchant_id: 29744,
          user_id: 97051,
          card_number: "434505******9116",
          transaction_date: "2019-11-31T23:16:32.812632",
          transaction_amount: 373,
          device_id: 285475
        }
        data = { data: 'secret' }
        token = JsonWebToken.encode(data)
        valid_headers = { 'Authorization' => "Bearer #{token}" }

        request.headers.merge!(valid_headers)

        expect {
          post :check_transaction, params: transaction_attributes
        }.to change(Transaction, :count).by(1)
      end

      it 'returns reject recommendation' do
        create(
          :transaction,
          user_id: 97051,
          card_number: '434505******9116',
          has_cbk: true
        )
        transaction_attributes = {
          transaction_id: 2342357,
          merchant_id: 29744,
          user_id: 97051,
          card_number: "434505******9116",
          transaction_date: "2019-11-31T23:16:32.812632",
          transaction_amount: 373,
          device_id: 285475
        }
        data = { data: 'secret' }
        token = JsonWebToken.encode(data)
        valid_headers = { 'Authorization' => "Bearer #{token}" }

        request.headers.merge!(valid_headers)
        post :check_transaction, params: transaction_attributes

        expect(response).to be_successful

        parsed_body = JSON.parse(response.body)

        expect(parsed_body['transaction_id']).to eq(transaction_attributes[:transaction_id])
        expect(parsed_body['recommendation']).to eq 'reject'
      end
    end

    context 'with invalid parameters' do
      it 'returns unprocessable entity status' do
        transaction_attributes = {}
        data = { data: 'secret' }
        token = JsonWebToken.encode(data)
        valid_headers = { 'Authorization' => "Bearer #{token}" }

        request.headers.merge!(valid_headers)
        post :check_transaction, params: transaction_attributes

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with invalid token' do
      it 'returns unauthorized status' do
        transaction_attributes = {}

        request.headers.merge!({ 'Authorization' => 'InvalidToken' })
        post :check_transaction, params: transaction_attributes

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
