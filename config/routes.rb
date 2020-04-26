# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
  }
  resources :users, only: %i[index show]
  root 'users#index'

  resources :avatars, only: %i[show create destroy update] do
    member do
      get :markerless_ar
    end
  end

  post '/callback', to: 'line_bots#callback'
  resources :line_bots, only: %i[new]
  resources :comments, only: %i[create destroy]
  resources :likes, only: %i[create destroy]
end
