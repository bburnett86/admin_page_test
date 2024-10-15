class WeatherController < ApplicationController
  def index
    location = WeatherService.get_location
    @weather = WeatherService.get_weather(location[:latitude], location[:longitude])
  rescue StandardError => e
    @error = e.message
  end
end