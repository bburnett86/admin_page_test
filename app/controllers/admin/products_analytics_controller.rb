# frozen_string_literal: true

module Admin
  class ProductsAnalyticsController < ApplicationController
    before_action :validate_admin

    def calculate_multiple_finance_line_graph_metrics
      excluded_types = params[:excluded_types]
      # Ensure all excluded_types are valid
      valid_types = %w[revenue cost profit average_check repeat_sales]
      return render json: { error: "Invalid excluded_types parameter" }, status: :bad_request unless excluded_types.is_a?(Array)
      return render json: { error: "Invalid excluded_types parameter" }, status: :bad_request unless excluded_types.all? { |type| valid_types.include?(type) }

      # Convert excluded_types to symbols after validation
      excluded_types.map!(&:to_sym)

      render json: Product.calculate_multiple_finance_line_graph_metrics(excluded_types)
    end

    def calculate_pipeline_chart_metrics
      target = params[:target].to_sym
      if %i[
        shopping_cart
        payment_methods
        delivery_methods
        confirm_order
        pending
        processed
        shipped
        cancelled
        delivered
        returned
        delayed
        returning
      ].exclude?(target)
        return render json: { error: "Invalid target parameter" }, status: :bad_request
      end

      render json: Product.calculate_pipeline_chart_metrics(target)
    end
  end
end
