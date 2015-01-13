Rails.application.routes.draw do
  match 'sign_up' => 'users#new', as: :sign_up, via: :get
  match 'sign_in' => 'sessions#new', as: :sign_in , via: :get
  match 'sign_out' => 'sessions#destroy', as: :sign_out, via: :delete

  root to: 'home#index'
  resources :users, only: [:new, :create, :index, :update, :edit]
  resources :sessions, only: [:new, :create, :destroy]
  resources :user_password, only: [:new, :create, :edit, :update]
  
end
