class Product < ApplicationRecord
  include ProductAnalytics
  
	has_many :order_items
  has_many :orders, through: :order_items
	has_many :tickets, as: :ticketable
  
  validates :name, presence: true, length: { minimum: 5 }, uniqueness: true
  validates :description, presence: true, length: { minimum: 10 }
  validates :inventory_count, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :active, inclusion: { in: [true, false] }
  validates :cost, presence: true, numericality: { greater_than: 0 }
	validates :current_price, presence: true, numericality: { greater_than: 0 }
	validates :sale_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
	validates :percentage_off, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :before_date, ->(end_date) { joins(:order_items).where('order_items.created_at < ?', end_date) }
end
