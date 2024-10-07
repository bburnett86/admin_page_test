# frozen_string_literal: true

Rails.application.routes.draw do
  get 'tickets/index'
  get 'tickets/show'
  get 'tickets/create'
  get 'tickets/update'
  get 'tickets/destroy'
  get 'order_items/index'
  get 'order_items/show'
  get 'order_items/create'
  get 'order_items/update'
  get 'order_items/destroy'
  get 'orders/index'
  get 'orders/show'
  get 'orders/create'
  get 'orders/update'
  get 'orders/destroy'
  get 'products/index'
  get 'products/show'
  get 'products/create'
  get 'products/update'
  get 'products/destroy'
  get 'users/index'
  get 'users/show'
  get 'users/create'
  get 'users/update'
  get 'users/destroy'
  devise_for :users
  get "pages", to: "pages#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#index"
end
