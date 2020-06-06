# frozen_string_literal: true

Rails.application.routes.draw do
  root 'users#index'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
  }
  resources :users, only: %i[index show] do
    member do
      get :following, :followers
    end
  end
  resources :relationships, only: %i[create destroy]
  resources :avatars, only: %i[show] do
    member do
      get :markerless_ar, :likers, :comments
    end
  end

  post '/callback', to: 'line_bots#callback'
  resources :line_bots, only: %i[new]

  # for Vue
  namespace :api, { format: 'json' } do
    namespace :v1 do
      resources :users, only: %i[update edit show] do
        member do
          get :following, :followers, :image, :liking
        end
        collection do
          post :check_password
        end
      end
      resources :avatars, only: %i[show index update create destroy] do
        member do
          get :likers, :comments
        end
      end
      resources :comments, only: %i[create destroy]
      resources :likes, only: %i[create destroy]
    end
  end
end
