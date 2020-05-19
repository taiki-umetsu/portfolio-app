# frozen_string_literal: true

Rails.application.routes.draw do
  root 'users#index'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
  }
  resources :users, only: %i[index show]

  resources :avatars, only: %i[show create destroy update] do
    member do
      get :markerless_ar
    end
  end

  post '/callback', to: 'line_bots#callback'
  resources :line_bots, only: %i[new]
  resources :comments, only: %i[create destroy]
  resources :likes, only: %i[create destroy]

  # for Vue
  namespace :api, { format: 'json' } do
    namespace :v1 do
      resources :users, only: %i[update edit show] do
        member do
          get :image
          get :liking
        end
      end
      resources :avatars, only: %i[show index update destroy]
      resources :comments, only: %i[create destroy]
      resources :likes, only: %i[create destroy]
    end
  end
end
