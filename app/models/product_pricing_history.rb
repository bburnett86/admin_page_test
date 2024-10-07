class ProductPricingHistory < ApplicationRecord
	belongs_to :product
	belongs_to :order_item
	belongs_to :order

	validates :product_id, presence: true
	validates :order_item_id, presence: true
	validates :order_id, presence: true


	def self.total_profit_before_date(end_date)
		total_revenue = OrderItem.where('created_at < ?', end_date).sum(:sale_price)
		total_cost = ProductPricingHistory.where('created_at < ?', end_date).sum(:cost)
		total_revenue - total_cost
	end
end
