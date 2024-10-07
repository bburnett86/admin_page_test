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
	
		def total_cancelled_orders_before_date(end_date)
			cancellations = Order.where('created_at < ?', end_date).where(status: 'cancelled').count
			{end_date: end_date, cancellations: cancellations}
		end
	
		def total_returned_orders_before_date(end_date)
			returns = Order.where('created_at < ?', end_date).where(status: 'returned').count
			{end_date: end_date, returns: returns}
		end
	
		def total_delivered_orders_before_date(end_date)
			delivered = Order.where('created_at < ?', end_date).where(status: 'delivered').count
			{end_date: end_date, delivered: delivered}
		end
	
		def total_delayed_orders_before_date(end_date)
			delayed = Order.where('created_at < ?', end_date).where(status: 'delayed').count
			{end_date: end_date, delayed: delayed}
		end
	
		def total_shipped_orders_before_date(end_date)
			shipped = Order.where('created_at < ?', end_date).where(status: 'shipped').count
			{end_date: end_date, shipped: shipped}
		end		
  end
end