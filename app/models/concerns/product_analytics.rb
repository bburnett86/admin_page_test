module ProductAnalytics
  extend ActiveSupport::Concern

  class_methods do
		def total_products_cancellations_before_date(end_date)
			cancellations = OrderItem.where('created_at < ?', end_date).where(status: 'cancelled').count
			{end_date: end_date, cancellations: cancellations}
		end
	
		def total_products_returns_before_date(end_date)
			returns = OrderItem.where('created_at < ?', end_date).where(status: 'returned').count
			{end_date: end_date, returns: returns}
		end
	
		def total_products_sold_before_date(end_date)
			sold = OrderItem.where('created_at < ?', end_date).where(status: 'delivered').count
			{end_date: end_date, sold: sold}
		end

		def total_revenue_before_date(end_date)
			OrderItem.where('created_at < ?', end_date).sum(:sale_price)
		end
	
		def total_cost_before_date(end_date)
			OrderItem.where('created_at < ?', end_date).sum(:cost)
		end

		def total_profit_before_date(end_date)
			total_revenue = OrderItem.where('created_at < ?', end_date).sum(:sale_price)
			total_cost = OrderItem.where('created_at < ?', end_date).sum(:cost)
			total_revenue - total_cost
		end

		def revenue_before_date(product_id, end_date)
			product = Product.find(product_id)
			product.orders.product_price_histories.where('created_at < ?', end_date).sum(:sale_price)
		end
	
		def profit_before_date(product_id, end_date)
			product = Product.find(product_id)
			revenue = product.orders.product_price_histories.where('product_price_histories.created_at < ?', end_date).sum(:sale_price)
			cost = product.order_items.where('order_items.created_at < ?', end_date).sum(:cost)
			revenue - cost
		end
	
		def product_cancellations_before_date(product_id, end_date)
			product = Product.find(product_id)
			cancellations = product.order_items.where('created_at < ?', end_date).where(product_id: product.id, status: 'cancelled').count
			{end_date: end_date, cancellations: cancellations}
		end
	
		def product_returns_before_date(product_id, end_date)
			product = Product.find(product_id)
			returns = product.order_items.where('created_at < ?', end_date).where(product_id: product.id, status: 'returned').count
			{end_date: end_date, returns: returns}
		end
	
		def products_sold_before_date(product_id, end_date)
			product = Product.find(product_id)
			sold = product.order_items.where('created_at < ?', end_date).where(product_id: product.id, status: 'delivered').count
			{end_date: end_date, sold: sold}
		end
	end
end
