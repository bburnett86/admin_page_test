require 'rails_helper'

RSpec.describe ProductAnalytics, type: :model do
  fixtures :products, :order_items
  let(:end_date) { Time.zone.now }
  
  describe ".total_products_cancellations_before_date" do
    it "returns correct cancellations count" do
      result = Product.total_products_cancellations_before_date(end_date)
      expect(result[:cancellations]).to eq(3)
    end
  end

  describe ".total_products_returns_before_date" do
    it "returns correct returns count" do
      result = Product.total_products_returns_before_date(end_date)
      expect(result[:returns]).to eq(5)
    end
  end

  describe ".total_products_sold_before_date" do
    it "returns correct sold count" do
      result = Product.total_products_sold_before_date(end_date)
      expect(result[:sold]).to eq(1)
    end
  end

  describe ".total_revenue_before_date" do
    it "calculates total revenue correctly" do
      revenue = Product.total_revenue_before_date(end_date)
      expect(revenue).to eq(624)
    end
  end

  describe ".total_cost_before_date" do
    it "calculates total cost correctly" do
      cost = Product.total_cost_before_date(end_date)
      expect(cost).to eq(320)
    end
  end

  describe ".total_profit_before_date" do
    it "calculates total profit correctly" do
      profit = Product.total_profit_before_date(end_date)
      expect(profit).to eq(304)
    end
  end
end