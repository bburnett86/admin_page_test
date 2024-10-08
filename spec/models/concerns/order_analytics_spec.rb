require 'rails_helper'

RSpec.describe OrderAnalytics, type: :model do
  let(:end_date) { Time.zone.now }

  describe '.total' do
    it 'returns the total count of orders' do
      expect(Order.total).to eq(8)
    end
  end

  describe '.total_orders_before_date' do
    it 'returns the count of orders before a specific date' do
      result = Order.total_orders_before_date(end_date)
      expect(result).to eq({end_date: end_date, orders: 8})
    end
  end

  describe '.total_cancelled_orders_before_date' do
    it 'returns the count of cancelled orders before a specific date' do
      result = Order.total_cancelled_orders_before_date(end_date)
      expect(result).to eq({end_date: end_date, cancelled: 1})
    end
  end

  describe '.total_returned_orders_before_date' do
    it 'returns the count of returned orders before a specific date' do
      result = Order.total_returned_orders_before_date(end_date)
      expect(result).to eq({end_date: end_date, returned: 1})
    end
  end

  describe '.total_delivered_orders_before_date' do
    it 'returns the count of delivered orders before a specific date' do
      result = Order.total_delivered_orders_before_date(end_date)
      expect(result).to eq({end_date: end_date, delivered: 1})
    end
  end

  describe '.total_delayed_orders_before_date' do
    it 'returns the count of delayed orders before a specific date' do
      result = Order.total_delayed_orders_before_date(end_date)
      expect(result).to eq({end_date: end_date, delayed: 1})
    end
  end

  describe '.total_shipped_orders_before_date' do
    it 'returns the count of shipped orders before a specific date' do
      result = Order.total_shipped_orders_before_date(end_date)
      expect(result).to eq({end_date: end_date, shipped: 1})
    end
  end
end