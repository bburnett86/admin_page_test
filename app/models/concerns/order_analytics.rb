module OrderAnalytics
  include ChartDateGenerator
  extend ActiveSupport::Concern

  class_methods do
    def total
      Order.count
    end

    def calculate(status = nil)
      end_dates = OrderAnalytics.create_chart_dates(7)
      data = end_dates.map do |end_date|
        count = if status
                  Order.before_date(end_date).by_status(status).count
                else
                  Order.before_date(end_date).count
                end
        { end_date: end_date, status: status || :orders, count: count }
      end.sort_by { |hash| -hash[:end_date].to_time.to_i }
      { data: data, name: status || :orders, x_axis_categories: end_dates }
    end

    private

    def total_orders_by_status_before_date(status = nil, end_date)
      raise ArgumentError, "Invalid status type" if !Order.statuses.include?(status) && !status.nil?
      count = !status.nil? ? Order.before_date(end_date).by_status(status).count : Order.before_date(end_date).count
      status ||= :orders
      { end_date: end_date, status: status, count: count }
    end
  end
end