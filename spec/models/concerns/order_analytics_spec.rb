# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrderAnalytics, type: :model do
  describe ".total" do
    it "returns the total count of orders" do
      expect(Order.total).to eq(Order.count)
    end
  end

  describe ".calculate_orders" do
    context "when status is specified" do
      it "calculates orders for the given status" do
        status = :shipped # Example status, adjust based on actual data
        result = Order.calculate_orders(status)
        # Example verification, adjust based on actual data and expected results
        expect(result[:name]).to eq(status.to_sym)
        expect(result[:data].length).to be_between(15, 17).inclusive
        expect(result[:data]).to eq(result[:data].sort_by { |h| h[:end_date] })
        expect(result[:data]).to eq(result[:data].sort_by { |h| h[:count] })
      end
    end

    context "when status is not specified" do
      it "calculates orders for all statuses" do
        result = Order.calculate_orders
        expect(result[:name]).to eq(:orders)
        expect(result[:data].length).to be_between(15, 17).inclusive
        expect(result[:data]).to eq(result[:data].sort_by { |h| h[:end_date] })
        expect(result[:data]).to eq(result[:data].sort_by { |h| h[:count] })
      end
    end
  end
end
