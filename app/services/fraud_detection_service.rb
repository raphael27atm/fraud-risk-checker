# frozen_string_literal: true

class FraudDetectionService
  attr_reader :transaction

  def initialize(transaction)
    @transaction = transaction
  end

  def check
    suspicious_device? ||
      device_change? ||
      card_chargeback? ||
      user_chargeback?(1, 5.days) ||
      multiple_small_transactions?(5, 1.day) ||
      high_transaction_amount?(1000.00, 5.days) ||
      retry_payment?(5, 1.days)
  end

  private

  def base_query
    @base_query ||= Transaction.where(user_id: transaction.user_id)
  end

  def suspicious_device?
    !transaction.device_id.present?
  end

  def device_change?
    last_device = base_query.order(transaction_date: :desc).limit(5).pluck(:device_id).uniq
    last_device.count > 2
  end

  def card_chargeback?
    Transaction.where(card_number: transaction.card_number.to_s.squish, has_cbk: true).exists?
  end

  def user_chargeback?(count, date)
    base_query.where(transaction_date: (transaction.transaction_date - date)..Float::INFINITY)
              .where(has_cbk: true).count >= count
  end

  def multiple_small_transactions?(count, date)
    base_query.where(transaction_date: (transaction.transaction_date - date)..transaction.transaction_date)
              .where(transaction_amount: 0..10.00)
              .count > count
  end

  def high_transaction_amount?(value, date)
    base_query.where(transaction_date: (transaction.transaction_date - date)..Float::INFINITY)
              .where(transaction_amount: value..Float::INFINITY)
              .exists?
  end

  def retry_payment?(count, date)
    base_query.where(transaction_date: (transaction.transaction_date - date)..Float::INFINITY)
              .count >= count
  end
end
