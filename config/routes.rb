Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :leagues
  resources :seasons
end
