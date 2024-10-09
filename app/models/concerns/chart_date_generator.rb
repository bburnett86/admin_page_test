module ChartDateGenerator
  extend ActiveSupport::Concern

	class_methods do
		def create_chart_dates(months_charted)
			end_date = Date.today
			start_date = end_date - months_charted.months
			dates = []

			while start_date <= end_date
				dates << start_date.beginning_of_month
				dates << start_date.beginning_of_month + 14.days
				start_date = start_date.next_month
			end

			if end_date.day.between?(2, 14)
				dates.delete(end_date.beginning_of_month)
			elsif end_date.day.between?(16, end_date.end_of_month.day - 1)
				dates.delete(end_date.beginning_of_month + 14.days)
			end

			dates
		end
	end
end