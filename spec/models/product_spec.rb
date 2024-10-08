# spec/models/product_spec.rb
require 'rails_helper'

RSpec.describe Product, type: :model do
  fixtures :products

  # Associations
  it { should have_many(:order_items) }
	it { should have_many(:orders).through(:order_items) }
	it { should have_many(:tickets)}

  # Validations
  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_least(5) }
  it { should validate_presence_of(:description) }
  it { should validate_length_of(:description).is_at_least(10) }
  it { should validate_numericality_of(:inventory_count).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:cost).is_greater_than(0) }
  it { should validate_numericality_of(:current_price).is_greater_than(0) }
  it { should validate_numericality_of(:sale_price).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:percentage_off).is_greater_than_or_equal_to(0) }

  # Scope
  describe '.before_date' do

    it 'returns total products with order_items created before the specified date' do
      expect(Product.before_date(Time.zone.now).length).to eq(24)
    end
  end

end