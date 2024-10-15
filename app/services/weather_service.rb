require 'httparty'

class WeatherService
  IPINFO_API_URL = 'https://ipinfo.io'
  OPENWEATHER_API_URL = 'https://api.openweathermap.org/data/2.5/weather'

  IPINFO_API_TOKEN = Rails.application.config.IPINFO_API_TOKEN
  OPENWEATHER_API_KEY = Rails.application.config.OPENWEATHER_API_KEY

  def self.get_location
    response = HTTParty.get("#{IPINFO_API_URL}?token=#{IPINFO_API_TOKEN}")
    loc = response['loc']
    latitude, longitude = loc.split(',')
    { latitude: latitude, longitude: longitude }
  rescue StandardError => e
    Rails.logger.error "Error fetching location from IPinfo: #{e.message}"
    raise
  end

  def self.get_weather(latitude, longitude)
    response = HTTParty.get(OPENWEATHER_API_URL, query: {
      lat: latitude,
      lon: longitude,
      appid: OPENWEATHER_API_KEY,
      units: 'metric'
    })
    raise StandardError, "Error fetching weather from OpenWeather: #{response.body}" unless response.success?
    response.parsed_response
  rescue StandardError => e
    Rails.logger.error "Error fetching weather from OpenWeather: #{e.message}"
    raise
  end
end