class OrderItem < ApplicationRecord
	include StatusEnum

	belongs_to :order, primary_key: 'id', foreign_key: 'order_id'
  belongs_to :product, primary_key: 'id', foreign_key: 'product_id'

	has_many :tickets, foreign_key: 'ticketable_id', as: 'ticketable'
	has_many :notifications, as: :notifiable

	after_update :handle_status_change, if: :saved_change_to_status?

	validates :order_id, presence: true
	validates :product_id, presence: true
	validates :expected_delivery_date, presence: true
	validates :cost, presence: true, numericality: { greater_than: 0 }
	validates :current_price, presence: true, numericality: { greater_than: 0 }
	validates :sale_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
	validates :percentage_off, presence: true, numericality: { greater_than_or_equal_to: 0 }

	def handle_status_change
		notification_details = 
			case status
			when 'delayed'
				{ description: "Your order has been delayed. It is now expected to arrive by #{order.expected_delivery_date.strftime("%Y-%m-%d")}.", status: "warning" }
			when 'cancelled'
				{ description: "On order #{order.id} item #{product.name} has been cancelled", status: "error" }
			when 'returning'
				{ description: "On order #{order.id} the return of item #{product.name} has been accepted", status: "success" }
			when 'returned'
				{ description: "On order #{order.id} item #{product.name} has been returned", status: "success" }
			else
				return
			end
	
		send_notification(notification_details)
	end

	def find_popular_companion_items
		orders_with_current_item = self.order_id
	
		popular_items = 
			OrderItem.where(order_id: orders_with_current_item)
				.where.not(id: self.id)
				.joins(:product)
				.group('products.name')
				.order('COUNT(products.name) DESC')
				.limit(2)
				.count('products.name')
	
		popular_items.keys
	end

  private

	def send_notification(details)
		CreateNotificationJob.perform_later(creator: self.order.user, notifiable: self, description: details[:description], status: details[:status])
	end

end
