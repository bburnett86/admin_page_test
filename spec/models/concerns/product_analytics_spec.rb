require 'rails_helper'

RSpec.describe ProductAnalytics, type: :model do

  describe '.calculate_totals' do
    context 'when calculating economic totals' do
      [:revenue, :cost, :profit].each do |type|
        end_dates = ProductAnalytics.create_chart_dates(7)
        it "calculates #{type} totals before specific dates" do
          result = Product.calculate_totals(type)
          expect(result[:data]).not_to be_empty
          expect(result[:name]).to eq(type)
          expect(result[:x_axis_categories]).to match_array(end_dates)
        end
      end
      it "raises an ArgumentError for invalid economic type" do
        expect { Product.calculate_totals(:invalid_type) }.to raise_error(ArgumentError)
      end
    end

    context 'when calculating status totals' do
      OrderItem.statuses.keys.each do |status|
        it "calculates totals for #{status} status before specific dates" do
          end_dates = ProductAnalytics.create_chart_dates(7)
          result = Product.calculate_totals(status.to_sym)
          expect(result[:data]).not_to be_empty
          expect(result[:name]).to eq(status.to_sym)
          expect(result[:x_axis_categories]).to match_array(end_dates)
        end
      end
      it "raises an ArgumentError for invalid status type" do
        expect { Product.calculate_totals(:invalid_status) }.to raise_error(ArgumentError)
      end
    end

    context 'with invalid type' do
      it 'raises an ArgumentError' do
        expect { Product.calculate_totals(:invalid_type) }.to raise_error(ArgumentError)
      end
    end
  end
end