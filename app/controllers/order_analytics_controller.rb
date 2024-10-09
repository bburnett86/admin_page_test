class OrderAnalyticsController < ApplicationController
	def calculate_totals
		type = params[:type].to_sym
		render json: OrderAnalytics.calculate_totals(type)
	end
end
