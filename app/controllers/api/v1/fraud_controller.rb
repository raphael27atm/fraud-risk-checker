# frozen_string_literal: true

module API::V1
  class FraudController < ApplicationController
    before_action :validate_transaction!

    def check_transaction
      if FraudDetectionService.new(@transaction).check
        render json: {
          transaction_id: @transaction.transaction_id,
          recommendation: 'deny'
        }
      else
        @transaction.save

        render json: {
          transaction_id: @transaction.transaction_id,
          recommendation: 'approve'
        }
      end
    end

    private

    def validate_transaction!
      @transaction = Transaction.new(transaction_params)

      unless @transaction.valid?
        render json: {
          errors: @transaction.errors.full_messages
        }, status: :unprocessable_entity
      end
    end

    def transaction_params
      params.permit(
        :transaction_id,
        :merchant_id,
        :user_id,
        :card_number,
        :transaction_date,
        :transaction_amount,
        :device_id
      )
    end
  end
end
