# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrderItem, type: :model do
  fixtures :order_items, :orders, :products

  describe "associations" do
    it { should belong_to(:order) }
    it { should belong_to(:product) }
  end

  describe "validations" do
    context "numericality" do
      subject { OrderItem.new(order_id: 1, product_id: 1) }

      it "validates numericality of cost with custom message" do
        subject.cost = -1
        subject.validate
        expect(subject.errors[:cost]).to include("must be greater than 0")
      end

      it "validates numericality of current_price with custom message" do
        subject.current_price = -1
        subject.validate
        expect(subject.errors[:current_price]).to include("must be greater than 0")
      end

      it "validates numericality of sale_price with custom message" do
        subject.sale_price = -1
        subject.validate
        expect(subject.errors[:sale_price]).to include("must be greater than or equal to 0")
      end

      it "validates numericality of percentage_off with custom message" do
        subject.percentage_off = -1
        subject.validate
        expect(subject.errors[:percentage_off]).to include("must be greater than or equal to 0")
      end
    end
  end
end
