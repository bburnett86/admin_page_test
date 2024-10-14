# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProductAnalytics, type: :model do
  fixtures :products

  describe "#multiple_finance_line_graph_metrics" do
    context "when product_id is valid" do
      context "with no excluded types" do
        it "returns data for all types" do
          product = products(:product_one)
          result = product.calculate_multiple_finance_line_graph_metrics([])
          expect(result.size).to eq(5)
          expected_types = %i[revenue cost profit average_check repeat_sales]
          result_types = result.map { |hash| hash[:name] }
          expect(result_types).to match_array(expected_types)
        end
      end

      context "with an excluded type" do
        it "excludes specified types from the result" do
          product = products(:product_one)
          excluded_types = [:cost]
          result = product.calculate_multiple_finance_line_graph_metrics(excluded_types)
          expect(result.flatten).not_to include(:cost)
        end
      end
    end

    context "when product_id is invalid" do
      it "raises ArgumentError" do
        product = products(:product_one)
        invalid_product_id = nil
        expect { product.calculate_multiple_finance_line_graph_metrics([], invalid_product_id) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#calculate_finance_line_graph_metrics" do
    context "when product_id is valid" do
      it "raises no error" do
        product = products(:product_one)
        expect { product.calculate_finance_line_graph_metrics(:revenue) }.not_to raise_error
      end

      context "with revenue type" do
        it "returns a hash with expected keys for revenue metrics" do
          product = products(:product_one)
          result = product.calculate_finance_line_graph_metrics(:revenue)
          expect(result.keys).to match_array(%i[data name x_axis_categories])
        end
      end

      context "with profit type" do
        it "returns a hash with expected keys for profit metrics" do
          product = products(:product_one)
          result = product.calculate_finance_line_graph_metrics(:profit)
          expect(result.keys).to match_array(%i[data name x_axis_categories])
        end
      end
    end

    context "when product_id is invalid" do
      it "raises ArgumentError" do
        product = products(:product_one)
        expect { product.calculate_finance_line_graph_metrics(:revenue, nil) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#calculate_pipeline_chart_metrics" do
    context "with valid target and product_id" do
      it "returns expected data structure" do
        product = products(:product_one)
        result = product.calculate_pipeline_chart_metrics(:confirm_order)
        expect(result).to be_an(Array)
        # Further assertions on the structure and content of result
      end
    end

    context "with :shipped target" do
      it "returns an array with expected structure for :shipped metrics" do
        product = products(:product_one)
        result = product.calculate_pipeline_chart_metrics(:shipped)
        expect(result).to all(include(:categories, :name, :data, :percentage))
      end
    end

    context "with :confirm_order target" do
      it "returns an array with expected structure for :confirm_order metrics" do
        product = products(:product_one)
        result = product.calculate_pipeline_chart_metrics(:confirm_order)
        expect(result).to all(include(:categories, :name, :data, :percentage))
      end
    end
  end

  describe "#calculate_individual_circle_graph_data_by_in_progress_status" do
    it "returns an array of hashes with expected keys" do
      product = products(:product_one)
      result = product.calculate_individual_circle_graph_data_by_in_progress_status
      expect(result).to all(include(:name, :value))
    end
  end

  describe "#calculate_individual_ytd_totals" do
    it "returns a hash with expected keys" do
      product = products(:product_one)
      result = product.calculate_individual_ytd_totals
      expect(result.keys).to match_array(%i[ytd_total_revenue ytd_total_profit ytd_repeat_sales ytd_average_check])
    end
  end
end
