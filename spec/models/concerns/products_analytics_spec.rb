# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductsAnalytics, type: :model do
  fixtures :products, :order_items, :orders

  describe '.calculate_multiple_finance_line_graph_metrics' do
    it 'returns metrics for all types when no types are excluded' do
      result = Product.calculate_multiple_finance_line_graph_metrics
      expect(result).to be_an(Array)
      expect(result.size).to eq(7)
    end

    it 'raises an error for invalid excluded types' do
      expect { Product.calculate_multiple_finance_line_graph_metrics([:invalid_type]) }.to raise_error(ArgumentError, 'Invalid excluded_types')
    end
  end

  describe '.calculate_products_finance_line_graph_data_by_time' do
    it 'returns metrics for a valid type' do
      result = Product.calculate_products_finance_line_graph_data_by_time(:revenue)
      expect(result).to be_a(Hash)
      expect(result[:name]).to eq(:revenue)
    end

    it 'raises an error for an invalid type' do
      expect { Product.calculate_products_finance_line_graph_data_by_time(:invalid_type) }.to raise_error(ArgumentError, 'Invalid type')
    end
  end

  describe '.calculate_products_bar_graph_data_by_pre_sale_status' do
    it 'returns metrics for pre-sale statuses' do
      result = Product.calculate_products_bar_graph_data_by_pre_sale_status
      expect(result).to be_an(Array)
    end
  end

  describe '.calculate_pipeline_chart_metrics' do
    it 'returns metrics for a valid target' do
      result = Product.calculate_pipeline_chart_metrics(:add_to_cart)
      expect(result).to be_an(Array)
    end

    it "raises an error for an invalid target" do
      expect { Product.calculate_pipeline_chart_metrics(:invalid_target) }.to raise_error(ArgumentError, "Invalid target")
    end
  end

  describe '.calculate_products_circle_graph_data_by_in_progress_status' do
    it 'returns data for in-progress statuses' do
      result = Product.calculate_products_circle_graph_data_by_in_progress_status
      expect(result).to be_an(Array)
    end
  end

  describe '.calculate_products_circle_graph_by_processed_status' do
    it 'returns data for processed statuses' do
      result = Product.calculate_products_circle_graph_by_processed_status
      expect(result).to be_an(Array)
    end
  end

  describe '.calculate_average_check_by_date' do
    it 'returns average check for a valid end_date' do
      end_date = Date.today
      result = Product.send(:calculate_average_check_by_date, end_date)
      expect(result).to be_a(Hash)
      expect(result[:end_date]).to eq(end_date)
    end

    it 'raises an error for an invalid end_date' do
      expect { Product.send(:calculate_average_check_by_date, 'invalid_date') }.to raise_error(ArgumentError, 'Invalid end_date')
    end
  end

  describe '.calculate_total_orders_by_date' do
    it 'returns total orders for a valid end_date' do
      end_date = Date.today
      result = Product.send(:calculate_total_orders_by_date, end_date)
      expect(result).to be_a(Hash)
      expect(result[:end_date]).to eq(end_date)
    end

    it 'raises an error for an invalid end_date' do
      expect { Product.send(:calculate_total_orders_by_date, 'invalid_date') }.to raise_error(ArgumentError, 'Invalid end_date')
    end
  end

  describe '.calculate_economic_totals_by_type' do
    it 'returns totals for a valid type and end_date' do
      end_date = Date.today
      result = Product.send(:calculate_economic_totals_by_type, :revenue, end_date)
      expect(result).to be_a(Hash)
      expect(result[:end_date]).to eq(end_date)
    end

    it 'raises an error for an invalid type' do
      end_date = Date.today
      expect { Product.send(:calculate_economic_totals_by_type, :invalid_type, end_date) }.to raise_error(ArgumentError, 'Invalid economic type')
    end

    it 'raises an error for an invalid end_date' do
      expect { Product.send(:calculate_economic_totals_by_type, :revenue, 'invalid_date') }.to raise_error(ArgumentError, 'Invalid end_date')
    end
  end

  describe '.calculate_repeat_sales_by_date' do
    it 'returns repeat sales for a valid end_date' do
      end_date = Date.today
      result = Product.send(:calculate_repeat_sales_by_date, end_date)
      expect(result).to be_a(Hash)
      expect(result[:end_date]).to eq(end_date)
    end

    it 'raises an error for an invalid end_date' do
      expect { Product.send(:calculate_repeat_sales_by_date, 'invalid_date') }.to raise_error(ArgumentError, 'Invalid end_date')
    end
  end

  describe '.calculate_economic_totals_by_status' do
    it 'returns totals for a valid status and end_date' do
      end_date = Date.today
      result = Product.send(:calculate_economic_totals_by_status, :cancelled, end_date)
      expect(result).to be_a(Hash)
      expect(result[:end_date]).to eq(end_date)
    end

    it 'raises an error for an invalid status' do
      end_date = Date.today
      expect { Product.send(:calculate_economic_totals_by_status, :invalid_status, end_date) }.to raise_error(ArgumentError, 'Invalid status type')
    end

    it 'raises an error for an invalid end_date' do
      expect { Product.send(:calculate_economic_totals_by_status, :cancelled, 'invalid_date') }.to raise_error(ArgumentError, 'Invalid end_date')
    end
  end
end