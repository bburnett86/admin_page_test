module UserAnalytics
  extend ActiveSupport::Concern

  class_methods do
		def count_repeat_items(user_id)
			OrderItem.joins(order: :user)
								.where(orders: {user_id: self.id, status: 'delivered'})
								.group(:product_id)
								.having('COUNT(*) > 1')
								.count
								.values
								.map { |count| count - 1 } 
								.sum
		end
	end
end
