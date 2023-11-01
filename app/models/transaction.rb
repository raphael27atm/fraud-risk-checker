class Transaction < ApplicationRecord
  validates :transaction_id, :merchant_id, :user_id,
            :card_number, :transaction_date, presence: true
  validates :transaction_id, :merchant_id,
            :user_id, numericality: { only_integer: true }

  validates :transaction_amount, presence: true, numericality: { greater_than: 0, message: 'must be a positive number' }

  validates :device_id, numericality: { only_integer: true }, allow_blank: true

  validate :valid_transaction_date
  validate :valid_card_number_format

  private

  def valid_transaction_date
    unless valid_date?(transaction_date)
      errors.add(:transaction_date, 'must be a valid date')
    end
  end

  def valid_date?(date_str)
    Date.parse(date_str.to_s) rescue false
  end

  def valid_card_number_format
    unless valid_card_number?(card_number)
      errors.add(:card_number, 'must be 16 characters long and contain only numbers and (*)asterisks')
    end
  end

  def valid_card_number?(card_number)
    card_number =~ /\A[\d*]{16}\z/
  end
end
