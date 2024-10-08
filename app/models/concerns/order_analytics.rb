module OrderAnalytics
  extend ActiveSupport::Concern

  class_methods do
		def total
			Order.all.count
		end

		def total_orders_before_date(end_date)
			orders = Order.where('created_at < ?', end_date).count
			{end_date: end_date, orders: orders}
		end
	
    def total_orders_before_date(end_date)
      total_orders_by_status_before_date(nil, end_date)
    end

    def total_cancelled_orders_before_date(end_date)
      total_orders_by_status_before_date(:cancelled, end_date)
    end

    def total_returned_orders_before_date(end_date)
      total_orders_by_status_before_date(:returned, end_date)
    end

    def total_delivered_orders_before_date(end_date)
      total_orders_by_status_before_date(:delivered, end_date)
    end

    def total_delayed_orders_before_date(end_date)
      total_orders_by_status_before_date(:delayed, end_date)
    end

    def total_shipped_orders_before_date(end_date)
      total_orders_by_status_before_date(:shipped, end_date)
    end

    private

    def total_orders_by_status_before_date(status, end_date)
      query = Order.before_date(end_date)
      query = query.by_status(status) if !status.nil?
			status = status.present? ? status : :orders
      count = query.count
      {end_date: end_date, status => count}
    end
  end
end