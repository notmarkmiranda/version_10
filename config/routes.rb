Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :leagues
  resources :seasons
  resources :game_users, only: [:create]
  resources :games do
    member do
      post 'complete'
      post 'uncomplete'
    end
  end
  resources :players, only: [:index, :create, :update, :destroy]
  resources :memberships, only: [:show, :create] do
    resource :approve, only: [:update]
    resource :reject, only: [:update]
  end

  resources :notifications, only: [:index, :show]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do

      get '/last_five_notifications', to: 'notifications#last_five'
      resources :notifications, only: [:show] do
        member do
          patch 'mark_as_read'
        end
        collection do
          patch 'mark_as_read'
        end
      end

      # Public facing API start
      namespace :leagues do
        get 'public'
      end
      # Public facing API end
    end
  end

  get '/user_stats/:user_id', to: 'user_stats#show', as: 'user_stats'
  get '/dashboard', to: 'dashboard#show', as: 'dashboard'
end
