require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:transaction) { build_stubbed(:transaction) }

  describe 'attributes' do
    it 'have the correct attributes', :aggregate_failures do
      expect(transaction).to respond_to :transaction_id
      expect(transaction).to respond_to :merchant_id
      expect(transaction).to respond_to :user_id
      expect(transaction).to respond_to :card_number
      expect(transaction).to respond_to :transaction_date
      expect(transaction).to respond_to :transaction_amount
      expect(transaction).to respond_to :device_id
      expect(transaction).to respond_to :has_cbk
    end
  end

  describe 'validations' do
    it 'have the correct validations', :aggregate_failures do
      expect(transaction).to validate_presence_of(:transaction_id)
      expect(transaction).to validate_presence_of(:merchant_id)
      expect(transaction).to validate_presence_of(:user_id)
      expect(transaction).to validate_presence_of(:card_number)
      expect(transaction).to validate_presence_of(:transaction_date)
      expect(transaction).to validate_presence_of(:transaction_amount)
      expect(transaction).to validate_numericality_of(:transaction_id).only_integer
      expect(transaction).to validate_numericality_of(:user_id).only_integer
      expect(transaction).to validate_numericality_of(:transaction_amount).is_greater_than(0).with_message('must be a positive number')
      expect(transaction).to validate_numericality_of(:device_id).only_integer.allow_nil
    end

    it 'validates transaction_date' do
      transaction = Transaction.new(transaction_date: 'invalid_date')
      transaction.valid?

      expect(transaction.errors[:transaction_date]).to include('must be a valid date')
    end

    it 'validates card number format', :aggregate_failures do
      transaction = build(:transaction, card_number: '544731******2063')
      expect(transaction).to be_valid

      transaction = build(:transaction, card_number: '544731******')
      expect(transaction).to_not be_valid
    end
  end
end
