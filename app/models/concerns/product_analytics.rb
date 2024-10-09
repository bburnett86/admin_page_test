module ProductAnalytics
  include ChartDateGenerator
  extend ActiveSupport::Concern

  class_methods do
    def calculate_totals(type = :financial)
			end_dates = ProductAnalytics.create_chart_dates(7)
      data = end_dates.map do |end_date|
        case type
        when :revenue, :cost, :profit
          calculate_economic_totals_by_type(type, end_date)
        else
          calculate_status_totals_by_type(type, end_date)
        end
      end.sort_by { |hash| -hash[:end_date].to_time.to_i }
      { data: data, name: type, x_axis_categories: end_dates }
    end

    def calculate_individual_product_totals(type = :financial)
      end_dates = ProductAnalytics.create_chart_dates(7)
      data = end_dates.map do |end_date|
        calculate_product_totals_by_type(type, end_date).sort_by { |hash| -hash[:end_date].to_time.to_i }
        { data: data, name: type, x_axis_categories: end_dates }
      end
    end

    private

    def calculate_economic_totals_by_type(type, end_date)
      query = OrderItem.joins(:order).where("orders.created_at < ?", end_date)
      case type
      when :revenue
        { revenue: query.sum('sale_price'), end_date: end_date }
      when :cost
        { cost: query.sum('cost'), end_date: end_date }
      when :profit
        revenue = query.sum('sale_price')
        cost = query.sum('cost')
        { profit: revenue - cost, end_date: end_date }
			else
				raise ArgumentError, "Invalid economic type"
      end
    end

    def calculate_status_totals_by_type(status, end_date)
			raise ArgumentError, "Invalid status type" unless OrderItem.statuses.include?(status)
      query = OrderItem.joins(:order).where("orders.created_at < ?", end_date).where(status: status)
      total = query.count
      { status => total, end_date: end_date }
    end
  end

  def product_totals_by_type(type, end_date)
    raise ArgumentError, "Invalid economic type" unless [:revenue, :cost, :profit].include?(type)
    product_id = self.product.id
    query = OrderItem.joins(:order).where("orders.created_at < ?", end_date).where(product_id: product_id)
    
    case type
    when :revenue
      { revenue: query.sum('sale_price'), end_date: end_date }
    when :cost
      { cost: query.sum('cost'), end_date: end_date }
    when :profit
      revenue = query.sum('sale_price')
      cost = query.sum('cost')
      { profit: revenue - cost, end_date: end_date }
    end
  end
end