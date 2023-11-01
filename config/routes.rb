Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check
  namespace :api do
    namespace :v1 do
      post 'fraud/check_transaction', to: 'fraud#check_transaction'
    end
  end
end
