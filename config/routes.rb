# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :users
  root 'users#index'
  resources :avatars, only: %i[create show destroy]
end
