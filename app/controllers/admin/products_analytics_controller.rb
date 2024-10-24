module Admin
  class ProductsAnalyticsController < ApplicationController
    before_action :validate_admin

    def line_graph_data
      type = params[:type] || "revenue"
      begin
        @line_graph_data = Product.calculate_products_finance_line_graph_data_by_time(type)
        respond_to do |format|
          format.json { render json: { display_data: @line_graph_data } }
        end
      rescue ArgumentError => e
        respond_to do |format|
          format.json { render json: { error: e.message }, status: :unprocessable_entity }
        end
      end
    end

    def calculate_multiple_finance_line_graph_metrics
      begin
        @line_graph_data = Product.calculate_multiple_finance_line_graph_metrics(params[:excluded_types] || [])
        respond_to do |format|
          format.json { render json: { line_graph_data: @line_graph_data } }
        end
      rescue ArgumentError => e
        Rails.logger.error("ArgumentError: #{e.message}")
        respond_to do |format|
          format.json { render json: { error: e.message }, status: :unprocessable_entity }
        end
      rescue StandardError => e
        Rails.logger.error("StandardError: #{e.message}")
        respond_to do |format|
          format.json { render json: { error: 'Internal Server Error' }, status: :internal_server_error }
        end
      end
    end
  end
end