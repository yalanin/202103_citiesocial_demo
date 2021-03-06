Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root 'products#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :products, only: [:index, :show]
  resources :categories, only: [:show]
  resource :cart, only: [:show, :destroy] do
    get :checkout, on: :collection
  end

  resources :orders, except: %i[new edit update destroy] do
    delete :cancel, on: :member
    get :confirm, on: :collection
    post :pay, on: :member
    get :pay_confirm, on: :member
  end

  namespace :admin do
    root 'products#index'
    resources :products, except: [:show]
    resources :vendors, except: [:show]
    resources :categories, except: [:show] do
      put :sort, on: :collection
    end
  end

  # api/v1
  namespace :api do
    namespace :v1 do
      post 'subscribe', to: 'utils#subscribe'
      post 'cart', to: 'utils#cart'
    end
  end
end
