# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :dashboard, only: [:index]
    resources :products_analytics, only: [] do
      collection do
        get :line_graph_data
        get :calculate_multiple_finance_line_graph_metrics
      end
    end

    resources :ticket_analytics, only: [] do
      collection do
        get :sorted_tickets_by_status
        get :calculate_ticket_totals
      end
    end
  end
  devise_for :users, controllers: {
    sessions: 'sessions'
  }
  # get "pages", to: "pages#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "admin/dashboard#index"
end