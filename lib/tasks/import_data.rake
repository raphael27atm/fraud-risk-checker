# frozen_string_literal: true

namespace :import do
  desc 'Import data'
  task run: :environment do
    file_path = "#{Rails.root}/db/data/data.csv"

    CSV.foreach(file_path, headers: true) do |row|
      transaction = Transaction.new(
        transaction_id: row['transaction_id'],
        merchant_id: row['merchant_id'],
        user_id: row['user_id'],
        card_number: row['card_number'],
        transaction_date: row['transaction_date'],
        transaction_amount: row['transaction_amount'],
        device_id: row['device_id'],
        has_cbk: row['has_cbk'] == 'TRUE'
      )

      transaction.save
    end
  end
end
