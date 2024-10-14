# frozen_string_literal: true

module ProductAnalytics
  extend ActiveSupport::Concern
  # Multiple Finance Metrics for Individual Product
  def calculate_multiple_finance_line_graph_metrics(exlucded_types = [])
    types = %i[revenue cost profit average_check repeat_sales]
    raise ArgumentError, "Invalid type" unless exlucded_types.all? { |type| types.include?(type.to_sym) }

    types -= exlucded_types
    types.map do |type|
      calculate_finance_line_graph_metrics(type)
    end
  end

  # Individual Product Financial Values For Line Chart
  def calculate_finance_line_graph_metrics(type = :revenue)
    raise ArgumentError, "Invalid type" unless %i[revenue cost profit average_check repeat_sales].include?(type)

    end_dates = Product.create_chart_dates(7)
    data = end_dates.map do |end_date|
      calculate_product_totals_by_type(type, end_date)
    end

    sorted_data = data.sort_by { |hash| hash[:end_date].to_time.to_i }
    { data: sorted_data, name: type, x_axis_categories: end_dates }
  end

  # Individual Product Financial Values For Bar Chart
  def calculate_pipeline_chart_metrics(target)
    res = []
    target = target.to_sym if target.is_a?(String)

    selected_statuses = %i[add_to_cart
                           shopping_cart
                           payment_methods
                           delivery_methods
                           confirm_order
                           pending
                           processed
                           shipped
                           cancelled
                           delivered
                           returned
                           delayed
                           returning]

    index = selected_statuses.index(target)
    selected_statuses = selected_statuses.slice!(index + 1..-1)

    query = OrderItem.joins(:order).where(product_id: id).where(status: selected_statuses)

    total_count = query.count
    current_count = query.count

    selected_statuses.each do |status|
      percentage = (current_count.to_f / total_count * 100).round(2)

      res.push({
                 name: "percentage",
                 data: current_count,
                 categories: [Product.format_status(status)],
                 percentage: percentage,
               })
      current_count -= query.where(status: status).count
    end

    res
  end

  # Individual Product Totals For Returned Orders vs Delivered Orders vs In Progress Orders Circle Graph
  def calculate_individual_circle_graph_data_by_in_progress_status
    in_progress_statuses = %i[add_to_cart shopping_cart payment_methods delivery_methods confirm_order shipped returning]

    returned_statuses = %i[cancelled returned]

    delivered = OrderItem.joins(:order).where(product_id: id).where(status: :delivered).count
    returned = OrderItem.joins(:order).where(product_id: id).where(status: returned_statuses).count
    in_progress = OrderItem.joins(:order).where(product_id: id).where(status: in_progress_statuses).count

    [{ name: "Delivered", value: delivered }, { name: "Returned", value: returned }, { name: "In Progress", value: in_progress }]
  end

  # Calculate Totals for Individual Product YTD Values
  def calculate_individual_ytd_totals
    ytd_total_revenue = OrderItem.joins(:order).where(product_id: id).sum("sale_price")

    ytd_total_profit = OrderItem.joins(:order).where(product_id: id).sum("sale_price") - OrderItem.joins(:order).where(product_id: id).sum("cost")

    ytd_repeat_sales = OrderItem.joins(:order).where(product_id: id).where(order_id: OrderItem.group(:order_id).having("count(order_id) > 1").pluck(:order_id)).count

    ytd_average_check = OrderItem.joins(:order).where(product_id: id).count / OrderItem.joins(:order).where(product_id: id).sum("sale_price")

    { ytd_total_revenue: ytd_total_revenue, ytd_total_profit: ytd_total_profit, ytd_repeat_sales: ytd_repeat_sales, ytd_average_check: ytd_average_check }
  end

private

  def base_query(end_date)
    raise ArgumentError, "Invalid end_date" unless end_date.is_a?(Date)

    OrderItem.joins(:order).where("orders.created_at < ?", end_date)
  end

  # Individual Product Financial Values For Line Chart
  def calculate_product_totals_by_type(type, end_date)
    raise ArgumentError, "Invalid end_date" unless end_date.is_a?(Date)

    query = base_query(end_date).where(product_id: id)

    case type
    when :revenue
      { revenue: query.sum("sale_price"), end_date: end_date }
    when :cost
      { cost: query.sum("cost"), end_date: end_date }
    when :profit
      revenue = query.sum("sale_price")
      cost = query.sum("cost")
      { profit: revenue - cost, end_date: end_date }
    when :average_check
      total = query.count
      total_revenue = query.sum("sale_price")
      average_check = total_revenue / total
      { average_check: average_check, end_date: end_date }
    when :repeat_sales
      repeat_sales = query.where(order_id: OrderItem.group(:order_id).having("count(order_id) > 1").pluck(:order_id)).count
      { repeat_sales: repeat_sales, end_date: end_date }

    when :cancelled
      cancelled = query.where(status: :cancelled).count
      { cancelled: cancelled, end_date: end_date }
    end
  end
end
