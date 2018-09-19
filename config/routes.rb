Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :leagues
  resources :seasons
  resources :games
  resources :notifications, only: [:index]

  get '/user_stats/:user_id', to: 'user_stats#show', as: 'user_stats'
  get '/dashboard', to: 'dashboard#show', as: 'dashboard'
end
