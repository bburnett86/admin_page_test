# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :products_analytics, only: [] do
      collection do
        get "calculate_multiple_finance_line_graph_metrics"
        get "calculate_pipeline_chart_metrics"
      end
    end

    resources :ticket_analytics, only: [] do
      collection do
        get "sorted_tickets_by_status"
        get "calculate_ticket_totals"
      end
    end
  end
  resources :dashboard, only: [:index]
  mount_devise_token_auth_for "User", at: "auth"
  get "pages", to: "pages#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "dashboard#index"
  # root "pages#index"
end
