# spec/services/weather_service_spec.rb
require 'rails_helper'
require 'webmock/rspec'

RSpec.describe WeatherService, type: :service do
  describe '.get_location' do
    context 'when the request is successful' do
      it 'returns the latitude and longitude' do
        response_body = { 'loc' => '37.7749,-122.4194' }.to_json
        stub_request(:get, "#{WeatherService::IPINFO_API_URL}?token=#{WeatherService::IPINFO_API_TOKEN}")
          .to_return(status: 200, body: response_body, headers: { 'Content-Type' => 'application/json' })

        location = WeatherService.get_location

        expect(location).to eq({ latitude: '37.7749', longitude: '-122.4194' })
      end
    end

    context 'when the request fails' do
      it 'raises an error' do
        stub_request(:get, "#{WeatherService::IPINFO_API_URL}?token=#{WeatherService::IPINFO_API_TOKEN}")
          .to_return(status: 500, body: '', headers: {})

        expect { WeatherService.get_location }.to raise_error(StandardError)
      end
    end
  end

  describe '.get_weather' do
    let(:latitude) { '37.7749' }
    let(:longitude) { '-122.4194' }

    context 'when the request is successful' do
      it 'returns the weather information' do
        response_body = {
          'name' => 'San Francisco',
          'main' => { 'temp' => 15.0 },
          'weather' => [{ 'description' => 'clear sky' }]
        }.to_json
        stub_request(:get, WeatherService::OPENWEATHER_API_URL)
          .with(query: { lat: latitude, lon: longitude, appid: WeatherService::OPENWEATHER_API_KEY, units: 'metric' })
          .to_return(status: 200, body: response_body, headers: { 'Content-Type' => 'application/json' })

        weather = WeatherService.get_weather(latitude, longitude)

        expect(weather['name']).to eq('San Francisco')
        expect(weather['main']['temp']).to eq(15.0)
        expect(weather['weather'][0]['description']).to eq('clear sky')
      end
    end

    context 'when the request fails' do
      it 'raises an error' do
        stub_request(:get, WeatherService::OPENWEATHER_API_URL)
          .with(query: { lat: latitude, lon: longitude, appid: WeatherService::OPENWEATHER_API_KEY, units: 'metric' })
          .to_return(status: 500, body: '', headers: {})

        expect { WeatherService.get_weather(latitude, longitude) }.to raise_error(StandardError)
      end
    end
  end
end