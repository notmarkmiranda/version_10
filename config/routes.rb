Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :leagues
  resources :seasons
  resources :games

  get '/user_stats/:user_id', to: 'user_stats#show', as: 'user_stats'
end
