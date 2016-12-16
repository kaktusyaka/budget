Rails.application.routes.draw do
  devise_for :admins, skip: :registrations
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  resources :transactions do
    collection { get :chart_and_new_transaction_data }
  end

  resources :categories do
    collection { post :sort }
  end

  resources :pricing_plans, only: [:index] do
    member do
      get 'checkout'
      post 'upgrade_with_stripe'
      get 'paypal_express_checkout'
      get 'upgrade_with_paypal'
      get 'cancel_payment'
      get 'downgrade'
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks', registrations: 'users/registrations' }

  resources :home, only: [:index] do
    collection { post :send_contact_us }
  end

  root 'home#index'
end