require 'rails_helper'

RSpec.describe Product, type: :model do
  fixtures :products
  let(:end_date) { Time.now }

  describe '.total_items_by_status_before_date' do
    it 'returns the count of items by status before a specific date' do
      result = Product.total_items_by_status_before_date(:shipped, end_date)
      expect(result).to eq({end_date: end_date, shipped: 3})
    end
  end

  describe '.financial_totals_before_date' do
    it 'returns the financial totals before a specific date' do
      result = Product.financial_totals_before_date(end_date)
      expect(result).to eq({revenue: 320, cost: 165, profit: 155, end_date: end_date})
    end
  end

  describe '#revenue_before_date' do
    it 'returns the revenue before a specific date' do
      product = products(:product_one)
      expect(product.revenue_before_date(end_date)).to eq(
        { revenue: 40, end_date: end_date }
      )
    end
  end

  describe '#profit_before_date' do
    it 'calculates the profit before a specific date' do
      product = products(:product_one)
      expect(product.profit_before_date(end_date)).to eq({
        profit: 15, end_date: end_date
      })
    end
  end

  describe '#product_cancellations_before_date' do
    it 'counts the product cancellations before a specific date' do
      product = products(:product_one)
      expect(product.product_cancellations_before_date(end_date)).to eq({end_date: end_date, cancellations: 2})
    end
  end

  describe '#product_returns_before_date' do
    it 'counts the product returns before a specific date' do
      product = products(:product_one)
      expect(product.product_returns_before_date(end_date)).to eq({end_date: end_date, returns: 1})
    end
  end

  describe '#products_sold_before_date' do
    it 'counts the products sold before a specific date' do
      product = products(:product_one)
      expect(product.products_sold_before_date(end_date)).to eq({end_date: end_date, sold: 5})
    end
  end
end