require 'rails_helper'

RSpec.describe FraudDetectionService do
  describe '#check' do
    it 'returns true' do
      transaction = create(:transaction, device_id: nil)

      subject = described_class.new(transaction)

      expect(subject.check).to be_truthy
    end
  end

  describe 'private methods' do
    describe '#suspicious_device?' do
      context 'when device_id is not present' do
        it 'returns true' do
          transaction = build(:transaction, device_id: nil)

          subject = described_class.new(transaction)

          expect(subject.send(:suspicious_device?)).to be_truthy
        end
      end

      context 'when device_id is present' do
        it 'returns false' do
          transaction = build(:transaction, device_id: 1)

          subject = described_class.new(transaction)

          expect(subject.send(:suspicious_device?)).to be_falsey
        end
      end
    end

    describe '#device_change?' do
      context 'when there are more than 2 device changes in the last 5 transactions' do
        it 'returns true' do
          create(:transaction, device_id: 1)
          create(:transaction, device_id: 2)
          create(:transaction, device_id: 3)
          create(:transaction, device_id: 4)
          create(:transaction, device_id: 5)
          transaction = build(:transaction, device_id: 5)

          subject = described_class.new(transaction)

          expect(subject.send(:device_change?)).to be_truthy
        end
      end

      context 'when there are 2 or fewer device changes in the last 5 transactions' do
        it 'returns false' do
          create(:transaction, device_id: 1)
          create(:transaction, device_id: 1)
          create(:transaction, device_id: 1)
          create(:transaction, device_id: 2)
          create(:transaction, device_id: 2)
          transaction = build(:transaction, device_id: 2)

          subject = described_class.new(transaction)

          expect(subject.send(:device_change?)).to be_falsey
        end
      end
    end

    describe '#card_chargeback?' do
      context 'when there is a chargeback associated with the transaction card number' do
        it 'returns true' do
          create(:transaction, card_number: '434505******9116', has_cbk: true)
          transaction = build(:transaction, card_number: '434505******9116')

          subject = described_class.new(transaction)

          expect(subject.send(:card_chargeback?)).to be_truthy
        end
      end

      context 'when there is no chargeback associated with the transaction card number' do
        it 'returns false' do
          create(:transaction, card_number: '434505******9116', has_cbk: false)
          transaction = build(:transaction, card_number: '434505******9116')

          subject = described_class.new(transaction)

          expect(subject.send(:card_chargeback?)).to be_falsey
        end
      end
    end

    describe '#user_chargeback?' do
      context 'when the user has more than the specified chargebacks within the date range' do
        it 'returns true' do
          count = 2
          date =  5.days
          transaction_date = Time.now
          create(:transaction, has_cbk: true, transaction_date: transaction_date - 1.day)
          create(:transaction, has_cbk: true, transaction_date: transaction_date - 2.days)
          create(:transaction, has_cbk: true, transaction_date: transaction_date - 3.days)
          transaction = create(:transaction, transaction_date: transaction_date)

          subject = described_class.new(transaction)

          expect(subject.send(:user_chargeback?, count, date)).to be_truthy
        end
      end

      context 'when the user has exactly the specified chargebacks within the date range' do
        it 'returns true' do
          count = 2
          date =  5.days
          transaction_date = Time.now
          create(:transaction, has_cbk: true, transaction_date: transaction_date - 1.day)
          create(:transaction, has_cbk: true, transaction_date: transaction_date - 2.days)
          transaction = create(:transaction, transaction_date: transaction_date)

          subject = described_class.new(transaction)

          expect(subject.send(:user_chargeback?, count, date)).to be_truthy
        end
      end

      context 'when the user has fewer than the specified chargebacks within the date range' do
        it 'returns false' do
          count = 2
          date =  5.days
          transaction_date = Time.now
          create(:transaction, has_cbk: true, transaction_date: transaction_date - 1.day)
          transaction = create(:transaction, transaction_date: transaction_date)

          subject = described_class.new(transaction)

          expect(subject.send(:user_chargeback?, count, date)).to be_falsey
        end
      end

      context 'when the user has chargebacks outside the date range' do
        it 'returns false' do
          count = 2
          date =  5.days
          transaction_date = Time.now
          create(:transaction, has_cbk: true, transaction_date: transaction_date - 6.days)
          create(:transaction, has_cbk: true, transaction_date: transaction_date - 7.days)
          transaction = create(:transaction, transaction_date: transaction_date)

          subject = described_class.new(transaction)

          expect(subject.send(:user_chargeback?, count, date)).to be_falsey
        end
      end
    end

    describe '#multiple_small_transactions?' do
      pending 'waiting for implementation'
    end

    describe '#high_transaction_amount?s' do
      pending 'waiting for implementation'
    end

    describe '#retry_payment?' do
      pending 'waiting for implementation'
    end
  end
end
