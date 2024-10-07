require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  fixtures :order_items, :orders, :products

	describe 'associations' do
		it { should belong_to(:order) }
		it { should belong_to(:product) }
	end

describe 'validations' do
  context 'numericality' do
    subject { OrderItem.new(order_id: 1, product_id: 1) }

    it 'validates numericality of cost with custom message' do
      subject.cost = -1
      subject.validate
      expect(subject.errors[:cost]).to include('must be greater than 0')
    end

    it 'validates numericality of current_price with custom message' do
      subject.current_price = -1
      subject.validate
      expect(subject.errors[:current_price]).to include('must be greater than 0')
    end

    it 'validates numericality of sale_price with custom message' do
      subject.sale_price = -1
      subject.validate
      expect(subject.errors[:sale_price]).to include('must be greater than or equal to 0')
    end

    it 'validates numericality of percentage_off with custom message' do
      subject.percentage_off = -1
      subject.validate
      expect(subject.errors[:percentage_off]).to include('must be greater than or equal to 0')
    end
  end
end

	# Public Methods
	describe '#find_popular_companion_items' do
		it 'returns popular companion items' do
			order_item = order_items(:pending_order_item_one)
			expect(order_item.find_popular_companion_items).not_to be_empty
		end
	end

	# Private Method Functioanlity
	describe 'OrderItem status change notifications' do
		it 'enqueues a job to send a cancelled notification when status changes to cancelled' do
			order_item = order_items(:shipped_order_item_one)
			expect {
				order_item.update(status: 'cancelled')
			}.to have_enqueued_job(CreateNotificationJob).with(notifiable: order_item, creator: order_item.order.user, description: "On order #{order_item.order.id} item #{order_item.product.name} has been cancelled", status: "error")
		end
	
		it 'enqueues a job to send a returning notification when status changes to returning' do
			order_item = order_items(:delivered_order_item_one)
			expect {
				order_item.update(status: 'returning')
			}.to have_enqueued_job(CreateNotificationJob).with(notifiable: order_item, creator: order_item.order.user, description: "On order #{order_item.order.id} the return of item #{order_item.product.name} has been accepted", status: "success")
		end
	
		it 'enqueues a job to send a returned notification when status changes to returned' do
			order_item = order_items(:shipped_order_item_three)
			expect {
				order_item.update(status: 'returned')
			}.to have_enqueued_job(CreateNotificationJob).with(notifiable: order_item, creator: order_item.order.user, description: "On order #{order_item.order.id} item #{order_item.product.name} has been returned", status: "success")
		end
	end


end