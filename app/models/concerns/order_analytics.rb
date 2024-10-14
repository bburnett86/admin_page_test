# frozen_string_literal: true

module OrderAnalytics
  extend ActiveSupport::Concern

  class_methods do
    def total
      Order.count
    end

    def calculate_orders(status = nil)
      end_dates = Order.create_chart_dates(7)
      data = end_dates.map do |end_date|
        count = if status
                  Order.before_date(end_date).by_status(status).count
                else
                  Order.before_date(end_date).count
                end
        { end_date: end_date, status: status || :orders, count: count }
      end.sort_by { |hash| hash[:end_date].to_time.to_i }

      { data: data, name: status || :orders, x_axis_categories: end_dates }
    end
  end
end
