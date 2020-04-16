# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
  }
  resources :users, only: %i[index show]
  root 'users#index'

  resources :avatars, only: %i[show create destroy] do
    member do
      get :markerless_ar
    end
  end
end
