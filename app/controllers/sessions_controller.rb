# app/controllers/sessions_controller.rb
class SessionsController < Devise::SessionsController
  # def new
  #   begin
  #     location = WeatherService.get_location
  #     @weather = WeatherService.get_weather(location[:latitude], location[:longitude])
  #   rescue StandardError => e
  #     @error = e.message
  #     @weather = nil
  #   ensure
  #     super
  #   end
  # end

  # def create
  #   super do |resource|
  #     if resource.persisted? # Check if the resource was successfully saved
  #       redirect_to after_sign_in_path_for(resource) and return
  #     end
  #   end
  # end

  # def destroy
  #   super
  # end

  # def after_sign_in_path_for(resource)
  #   admin_dashboard_index_path + "?reload=true"
  # end
end