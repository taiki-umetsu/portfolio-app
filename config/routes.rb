# frozen_string_literal: true

Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  get 'users/new'
  get 'users/edit'
  root 'application#hello'
end
