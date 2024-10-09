class ProductAnalyticsController < ApplicationController
	def calculate_totals
		type = params[:type].to_sym
		render json: ProductAnalytics.calculate_totals(type)
	end
end
