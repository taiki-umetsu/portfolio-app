# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
  }
  resources :users
  root 'users#index'

  resources :avatars do
    collection do
      post :create
      delete :destroy
    end
    member do
      get :show
      get :markerless_ar
    end
  end
end
