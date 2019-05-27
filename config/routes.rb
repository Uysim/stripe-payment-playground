Rails.application.routes.draw do
  root to: 'home#index'

  resources :users do
    resources :shops

    member do
      get  :user_config
      post :pay
      post :subscribe
    end

    resources :payment_intents do
      member do
        get :shipping_change
        get :status
      end
    end
  end

  resource :sessions do
    member do
      get :destroy, as: 'destroy'
    end
  end

  # Stripe Connect endpoints
  #  - oauth flow
  get '/connect/oauth' => 'stripe#oauth', as: 'stripe_oauth'
  get '/connect/confirm' => 'stripe#confirm', as: 'stripe_confirm'
  get '/connect/deauthorize' => 'stripe#deauthorize', as: 'stripe_deauthorize'
  #  - create accounts
  post '/connect/managed' => 'stripe#managed', as: 'stripe_managed'
  post '/connect/standalone' => 'stripe#standalone', as: 'stripe_standalone'

  # Stripe webhooks
  post '/hooks/stripe' => 'hooks#stripe'



  resources :products do
    member do
      get :skus
    end
  end
end
