# frozen_string_literal: true

module ProductsAnalytics
  extend ActiveSupport::Concern

  class_methods do
    def calculate_multiple_finance_line_graph_metrics(excluded_types = [])
      raise ArgumentError, "excluded_types must be an array" unless excluded_types.is_a?(Array)

      types = %i[revenue cost profit average_check repeat_sales cancelled orders]

      raise ArgumentError, "Invalid excluded_types" unless (excluded_types - types).empty?

      types -= excluded_types
      types.map do |type|
        calculate_products_finance_line_graph_data_by_time(type)
      end
    end

    # All Product Sales Totals For One Economic Type Types
    def calculate_products_finance_line_graph_data_by_time(type = :revenue)
      type = type.to_sym unless type.is_a?(Symbol)

      raise ArgumentError, "Invalid type" unless %i[revenue cost profit average_check repeat_sales cancelled orders].include?(type) || OrderItem.statuses.keys.include?(type)


        end_dates = Product.create_chart_dates(7)
        data = end_dates.map do |end_date|
        raise ArgumentError, "Invalid end_date" unless end_date.is_a?(Date)

        case type
        when :revenue, :cost, :profit
          calculate_economic_totals_by_type(type, end_date)
        when :average_check
          calculate_average_check_by_date(end_date)
        when :repeat_sales
          calculate_repeat_sales_by_date(end_date)
        when :cancelled
          calculate_economic_totals_by_status(:cancelled, end_date)
        when :orders
          calculate_total_orders_by_date(end_date)
        else
          raise ArgumentError, "Invalid type"
        end
      end
      totals = data.sort_by { |hash| hash[:end_date].to_time.to_i }.map { |hash| hash[type].to_i }
      { data: totals, name: type, x_axis_categories: end_dates }
    end

    # Product by Order_Item Status totals for Bar Graph
    def calculate_products_bar_graph_data_by_pre_sale_status
      res = []
      selected_statuses = %i[add_to_cart shopping_cart payment_methods delivery_methods confirm_order shipped]
      query = OrderItem.joins(:order)
                       .where(status: selected_statuses)
      total_count = query.count

      selected_statuses.each do |status|
        # For 'add_to_cart', we use the total count of the query as its total, for others, we filter by status.
        total = status == "add_to_cart" ? total_count : query.where(status: status).count
        percentage = (total.to_f / total_count * 100).round(2)

        res.push({
                   name: "percentage",
                   data: total,
                   categories: status != "shipped" ? [Product.format_status(status.to_sym)] : ["Delivery"],
                   percentage: percentage,
                 })
      end

      res
    end

    # Product by Order_Item Status totals for Pipeline Graph
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
      selected_statuses = selected_statuses.slice(0..index)

      query = OrderItem.joins(:order).where(status: selected_statuses)

      total_count = query.count
      current_count = query.count

      selected_statuses.each do |status|
        percentage = (current_count.to_f / total_count * 100).round(2)

        res.push({
                   data: current_count,
                   label: Product.format_status(status),
                   percent: percentage,
                 })
        current_count -= query.where(status: status).count
      end

      res
    end

    # Product by Order_Item Status totals for Circle Graph
    def calculate_products_circle_graph_data_by_in_progress_status
      res = []
      selected_statuses = %i[add_to_cart shopping_cart payment_methods delivery_methods confirm_order shipped returning]

      query = OrderItem.joins(:order).where(status: selected_statuses)

      selected_statuses.each do |status|
        total = query.where(status: status).count
        res << { name: Product.format_status(status.to_sym), value: total }
      end
      res
    end

    # Product by Order_Item Status totals for Circle Graph
    def calculate_products_circle_graph_by_processed_status
      res = []
      selected_statuses = %i[processed cancelled delivered returned delayed shipped]

      query = OrderItem.joins(:order).where(status: selected_statuses)

      selected_statuses.each do |status|
        total = query.where(status: status).count
        res << { name: Product.format_status(status.to_sym), value: total }
      end
      res
    end

  private

    def base_query(end_date)
      raise ArgumentError, "Invalid end_date" unless end_date.is_a?(Date)

      OrderItem.joins(:order).where("orders.created_at < ?", end_date)
    end

    def calculate_average_check_by_date(end_date)
      raise ArgumentError, "Invalid end_date" unless end_date.is_a?(Date)

      query = base_query(end_date)
      total = query.count
      total_revenue = query.sum("sale_price")
      average_check = total_revenue / total
      { average_check: average_check, end_date: end_date }
    end

    def calculate_total_orders_by_date(end_date)
      raise ArgumentError, "Invalid end_date" unless end_date.is_a?(Date)

      total = Order.where("created_at < ?", end_date).count
      { orders: total, end_date: end_date }
    end

    def calculate_economic_totals_by_type(type, end_date)
      query = base_query(end_date)
      case type
      when :revenue
        { revenue: query.sum("sale_price"), end_date: end_date }
      when :cost
        { cost: query.sum("cost"), end_date: end_date }
      when :profit
        revenue = query.sum("sale_price")
        cost = query.sum("cost")
        { profit: revenue - cost, end_date: end_date }
      when :repeat_sales
        calculate_repeat_sales_by_date(end_date)
      when :cancelled
        calculate_economic_totals_by_status(:cancelled, end_date)
      else
        raise ArgumentError, "Invalid economic type"
      end
    end

    def calculate_repeat_sales_by_date(end_date)
      raise ArgumentError, "Invalid end_date" unless end_date.is_a?(Date)

      query = base_query(end_date)
      repeat_sales = query.where(order_id: OrderItem.group(:order_id).having("count(order_id) > 1").pluck(:order_id)).count
      { repeat_sales: repeat_sales, end_date: end_date }
    end

    def calculate_economic_totals_by_status(status, end_date)
      raise ArgumentError, "Invalid status type" unless OrderItem.statuses.include?(status)

      query = base_query(end_date).where(status: status)
      total = query.count
      { status => total, end_date: end_date }
    end
  end
end
