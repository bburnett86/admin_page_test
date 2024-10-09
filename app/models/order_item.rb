class OrderItem < ApplicationRecord
	include StatusEnum
	scope :before_date, ->(end_date) { where('created_at < ?', end_date) }

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

end
