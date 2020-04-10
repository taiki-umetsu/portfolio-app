# frozen_string_literal: true

Rails.application.routes.draw do
  get 'avatars/new'
  get 'avatars/show'
  devise_for :users
  resources :users
  root 'users#index'
end
