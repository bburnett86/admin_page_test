# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProductsAnalytics, type: :model do
  fixtures :products, :order_items, :orders

  describe ".calculate_multiple_finance_line_graph_metrics" do
    context "when excluded_types is not an array" do
      it "raises ArgumentError" do
        expect { Product.calculate_multiple_finance_line_graph_metrics("string") }.to raise_error(ArgumentError, "excluded_types must be an array")
      end
    end

    context "when excluded_types contains invalid types" do
      it "raises ArgumentError" do
        expect { Product.calculate_multiple_finance_line_graph_metrics([:invalid_type]) }.to raise_error(ArgumentError, "Invalid excluded_types")
      end
    end

    context "with valid excluded_types" do
      it "returns data excluding specified types" do
        result = Product.calculate_multiple_finance_line_graph_metrics(%i[revenue cost])
        expect(result.map { |hash| hash[:name] }).not_to include(:revenue, :cost)
      end
    end
  end

  describe "#calculate_pipeline_chart_metrics" do
    context "with valid target and product_id" do
      it "returns expected data structure" do
        result = Product.calculate_pipeline_chart_metrics(:confirm_order)
        expect(result).to be_an(Array)
        # Further assertions on the structure and content of result
      end
    end

    context "with :shipped target" do
      it "returns an array with expected structure for :shipped metrics" do
        result = Product.calculate_pipeline_chart_metrics(:shipped)
        expect(result).to all(include(:categories, :name, :data, :percentage))
      end
    end

    context "with :confirm_order target" do
      it "returns an array with expected structure for :confirm_order metrics" do
        result = Product.calculate_pipeline_chart_metrics(:confirm_order)
        expect(result).to all(include(:categories, :name, :data, :percentage))
      end
    end
  end

  describe ".calculate_products_finance_line_graph_data_by_time" do
    context "when type is invalid" do
      it "raises ArgumentError" do
        expect { Product.calculate_products_finance_line_graph_data_by_time(:invalid_type) }.to raise_error(ArgumentError, "Invalid type")
      end
    end

    context "when end_date is invalid" do
      it "raises ArgumentError" do
        allow(Product).to receive(:create_chart_dates).and_return(["invalid_date"])
        expect { Product.calculate_products_finance_line_graph_data_by_time(:revenue) }.to raise_error(ArgumentError, "Invalid end_date")
      end
    end

    context "with valid type and end_dates" do
      it "returns data for the specified type" do
        allow(Product).to receive(:create_chart_dates).and_return([Date.today])
        result = Product.calculate_products_finance_line_graph_data_by_time(:revenue)
        expect(result[:name]).to eq(:revenue)
      end
    end
  end

  describe ".calculate_products_bar_graph_data_by_pre_sale_status" do
    it "returns data for selected pre-sale statuses" do
      result = Product.calculate_products_bar_graph_data_by_pre_sale_status
      expect(result.size).to eq(6)
    end
  end

  describe ".calculate_products_circle_graph_data_by_in_progress_status" do
    it "returns data for in-progress statuses" do
      result = Product.calculate_products_circle_graph_data_by_in_progress_status
      expect(result).not_to be_empty
    end
  end

  describe ".calculate_products_circle_graph_by_processed_status" do
    it "returns data for processed statuses" do
      result = Product.calculate_products_circle_graph_by_processed_status
      expect(result).not_to be_empty
    end
  end

  # Testing private methods through public interface
  describe "Private methods" do
    context "calculate_average_check_by_date" do
      it "calculates average check correctly" do
        allow(Product).to receive(:create_chart_dates).and_return([Date.today])
        result = Product.calculate_products_finance_line_graph_data_by_time(:average_check)
        expect(result[:data].first).to have_key(:average_check)
      end
    end

    context "calculate_economic_totals_by_type" do
      it "calculates economic totals correctly" do
        allow(Product).to receive(:create_chart_dates).and_return([Date.today])
        result = Product.calculate_products_finance_line_graph_data_by_time(:revenue)
        expect(result[:data].first).to have_key(:revenue)
      end
    end

    context "calculate_repeat_sales_by_date" do
      it "calculates repeat sales correctly" do
        allow(Product).to receive(:create_chart_dates).and_return([Date.today])
        result = Product.calculate_products_finance_line_graph_data_by_time(:repeat_sales)
        expect(result[:data].first).to have_key(:repeat_sales)
      end
    end

    context "calculate_economic_totals_by_status" do
      it "calculates totals by status correctly" do
        allow(Product).to receive(:create_chart_dates).and_return([Date.today])
        result = Product.calculate_products_finance_line_graph_data_by_time(:cancelled)
        expect(result[:data].first).to have_key(:cancelled)
      end
    end
  end
end
