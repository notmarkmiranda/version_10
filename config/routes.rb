Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :leagues
  resources :seasons
  resources :games do
    member do
      post 'complete'
      post 'uncomplete'
    end
  end
  resources :players, only: [:index]
  resources :memberships, only: [:show] do
    resource :approve, only: [:update]
    resource :reject, only: [:update]
  end

  resources :notifications, only: [:index, :show]

  get '/user_stats/:user_id', to: 'user_stats#show', as: 'user_stats'
  get '/dashboard', to: 'dashboard#show', as: 'dashboard'
end
