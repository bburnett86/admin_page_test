module Admin
  class ProductsAnalyticsController < ApplicationController
    def line_graph_data
      type = params[:type] || "revenue"
      @line_graph_data = Product.calculate_products_finance_line_graph_data_by_time(type)
      respond_to do |format|
        format.json { render json: { display_data: @line_graph_data } }
      end
    end

    def calculate_multiple_finance_line_graph_metrics
      @line_graph_data = Product.calculate_multiple_finance_line_graph_metrics
      respond_to do |format|
        format.json { render json: { line_graph_data: @line_graph_data } }
      end
    end
  end
end