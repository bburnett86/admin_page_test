# spec/models/order_spec.rb
require 'rails_helper'

RSpec.describe Order, type: :model do
  fixtures :orders, :users, :products, :order_items

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:order_items) }
    it { should have_many(:products).through(:order_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:status) }
    it { should define_enum_for(:status).with_values(pending: 'pending', processed: 'processed', cancelled: 'cancelled', delivered: 'delivered', returned: 'returned', delayed: 'delayed', returning: 'returning', shipped: 'shipped').backed_by_column_of_type(:string) }
  end
  
  # Public Methods
	describe '#receipt' do
		it 'returns a receipt with correct total and item details' do
			order = orders(:pending_order)
			
			receipt = order.receipt
			expect(receipt[:total]).to eq(78)
			expect(receipt[:receipt][0][:sale_price]).to eq(8.00) 
			expect(receipt[:receipt][0][:original_price]).to eq(10.00)
			expect(receipt[:receipt][0][:percentage_off]).to eq(20)
		end
	end

  describe '#inventory_sold' do
    it 'decreases the product inventory by the ordered quantity' do
      order = orders(:pending_order)
      product = products(:product_one)
      
      expect { order.inventory_sold }.to change { product.reload.inventory_count }.by(-1)
    end
  end

  describe '#inventory_returned' do
    it 'increases the product inventory by the returned quantity' do
      order = orders(:returned_order)
      product = products(:product_one)
      
      expect { order.inventory_returned }.to change { product.reload.inventory_count }.by(1)
    end
  end

  # Private Method Functionality
  describe 'expected_delivery_date validation' do
    it 'is invalid if the expected_delivery_date is before the creation date for statuses other than pending, cancelled, delivered, returned, or returning' do
      order = Order.new(expected_delivery_date: 1.day.ago, created_at: Time.zone.now, status: 'processed')
      order.valid?
      expect(order.errors[:expected_delivery_date]).to include('must be after the order creation date and not blank for statuses other than pending, cancelled, delivered, returned, or returning')
    end
  end

	describe '#create_notification on order creation' do
  it 'enqueues a CreateNotificationJob when a new order is created' do
    user = users(:standard_user_one)

    expect {
			Order.create(user: user, status: 'pending', expected_delivery_date: 3.days.from_now)
    }.to have_enqueued_job(CreateNotificationJob)
		end
	end

  describe 'Order status change notifications' do
  
    it 'enqueues a job to send a delivered notification when status changes to delivered' do
			order = orders(:processed_order)
      expect {
        order.update(status: 'delivered')
      }.to have_enqueued_job(CreateNotificationJob).with(user: order.user, notifiable: order, description: "Your order #{order.id} has been delivered", status: "success")
    end
  
    it 'enqueues a job to send a cancelled notification when status changes to cancelled' do
			order = orders(:pending_order)
      expect {
        order.update(status: 'cancelled')
      }.to have_enqueued_job(CreateNotificationJob).with(user: order.user, notifiable: order, description: "Your order #{order.id} has been cancelled", status: "error")
    end
  
    it 'enqueues a job to send a returned notification when status changes to returned' do
			order = orders(:returning_order)
      expect {
        order.update(status: 'returned')
      }.to have_enqueued_job(CreateNotificationJob).with(user: order.user, notifiable: order, description: "Your order #{order.id} has been returned", status: "success")
    end
  
    it 'enqueues a job to send a shipped notification when status changes to shipped' do
			order = orders(:processed_order)
      expect {
        order.update(status: 'shipped')
      }.to have_enqueued_job(CreateNotificationJob).with(user: order.user, notifiable: order, description: "Your order #{order.id} has been shipped", status: "success")
    end
  end

  # Fixtures
  describe 'fixtures' do
    it 'has valid fixtures' do
      orders.each do |order|
        expect(order).to be_valid, order.errors.full_messages.join(", ")
      end
    end

    it 'associates orders correctly with users' do
      expect(users(:standard_user_one).orders).to include(orders(:pending_order), orders(:processed_order), orders(:cancelled_order), orders(:delivered_order))
      expect(users(:standard_user_two).orders).to include(orders(:returned_order), orders(:delayed_order), orders(:returning_order), orders(:shipped_order))
    end

    it 'associates order_items correctly with orders' do
      expect(orders(:pending_order).order_items).to match_array([order_items(:pending_order_item_one), order_items(:pending_order_item_two), order_items(:pending_order_item_three)])
      expect(orders(:processed_order).order_items).to match_array([order_items(:processed_order_item_one), order_items(:processed_order_item_two), order_items(:processed_order_item_three)])
      # Add similar checks for other orders as needed
    end
  end
end