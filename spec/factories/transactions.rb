FactoryBot.define do
  factory :transaction do
    transaction_id { 1 }
    merchant_id { 1 }
    user_id { 1 }
    card_number { '544731******2063' }
    transaction_date { Date.current }
    transaction_amount { 1.5 }
    device_id { 1 }
    has_cbk { false }
  end
end
