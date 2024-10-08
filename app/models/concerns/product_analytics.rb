module ProductAnalytics
  extend ActiveSupport::Concern

  class_methods do
		def total_items_by_status_before_date(status, end_date)
      count = Product.before_date(end_date).where(order_items: { status: status }).count

      {end_date: end_date, status => count}
    end

		def financial_totals_before_date(end_date)
			eligible_items = OrderItem.before_date(end_date).where.not(status: [:returned, :returning, :cancelled])
		
			total_revenue = eligible_items.sum(:sale_price)
			total_cost = eligible_items.sum(:cost)
			total_profit = total_revenue - total_cost
		
			{revenue: total_revenue, cost: total_cost, profit: total_profit, end_date: end_date}
		end
	end

	def financial_totals_before_date(end_date)
		total_revenue = OrderItem.joins(:order).where("orders.created_at < ?", end_date).where(product_id: self.id).where.not(status: [:returned, :returning, :cancelled]).sum('sale_price')
	
		total_cost = OrderItem.joins(:order).where("orders.created_at < ?", end_date).where(product_id: self.id).where.not(status: [:returned, :returning, :cancelled]).sum('cost')
	
		total_profit = total_revenue - total_cost
	
		{revenue: total_revenue, cost: total_cost, profit: total_profit, end_date: end_date}
	end
	
	def revenue_before_date(end_date)
		revenue = OrderItem.joins(:order).where("orders.created_at < ?", end_date).where(product_id: self.id).where.not(status: [:returned, :returning, :cancelled]).sum(:sale_price)

		{revenue: revenue, end_date: end_date}
	end
	
	def profit_before_date(end_date)
		eligible_items = OrderItem.before_date(end_date).where(product_id: self.id).where.not(status: [:returned, :returning, :cancelled])
	
		revenue = eligible_items.sum(:sale_price)
		cost = eligible_items.sum(:cost)
	
		profit = revenue - cost

		{end_date: end_date, profit: profit}
	end
	
	def products_sold_before_date(end_date)
		sold = OrderItem.joins(:order).where("orders.created_at < ?", end_date).where(product_id: self.id).where.not(status: [:returned, :returning, :cancelled]).count
		
		{end_date: end_date, sold: sold}
	end
	
	def product_cancellations_before_date(end_date)
		cancellations = OrderItem.joins(:order).where("orders.created_at < ?", end_date).where(product_id: self.id, status: 'cancelled').count

		{end_date: end_date, cancellations: cancellations}
	end
	
	def product_returns_before_date(end_date)
		returns = OrderItem.joins(:order).where("orders.created_at < ?", end_date).where(product_id: self.id, status: 'returned').count
		
		{end_date: end_date, returns: returns}
	end
	
end
