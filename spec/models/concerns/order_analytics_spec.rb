require 'rails_helper'

RSpec.describe OrderAnalytics, type: :model do

  describe '.total' do
    it 'returns the total count of orders' do
      total_orders = Order.count
      expect(Order.total).to eq(total_orders)
    end
  end

  describe '.total_orders_by_status_before_date' do
    statuses = Order.statuses.keys << nil
    end_date = Time.zone.now
    statuses.each do |status|
      context "with status: #{status}" do
        it "returns the count of #{status || 'all'} orders before a specific date" do
          result = Order.send(:total_orders_by_status_before_date, status, end_date)
          expected_count = if status
                             Order.before_date(end_date).by_status(status).count
                           else
                             Order.before_date(end_date).count
                           end
          expect(result[:count]).to eq(expected_count)
          expect(result[:status]).to eq(status || :orders)
          expect(result[:end_date]).to eq(end_date)
        end
      end
    end
    context 'with invalid status' do
      it 'with invalid status raises an ArgumentError' do
        end_date = Date.today
        expect { Order.send(:total_orders_by_status_before_date, :invalid_status, end_date) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '.calculate' do
    statuses = Order.statuses.keys << nil
    end_dates = OrderAnalytics.create_chart_dates(7)
    statuses.each do |status|
      context "with status: #{status}" do
        it "calculates order data for #{status || 'all'} orders across given end dates" do
          result = Order.calculate(status)
          expected_data = end_dates.map do |end_date|
            count = if status
                      Order.before_date(end_date).by_status(status).count
                    else
                      Order.before_date(end_date).count
                    end
            { end_date: end_date, status: status || :orders, count: count }
          end.sort_by { |hash| -hash[:end_date].to_time.to_i }
          expect(result[:data]).to eq(expected_data)
          expect(result[:name]).to eq(status || :orders)
          expect(result[:x_axis_categories]).to eq(end_dates)
        end
      end
    end
  end
end