class WeatherApi
  API_KEY = ENV['WEATHER_API_KEY'].freeze

  def self.fetch_weather(city)
    url = "https://api.weatherstack.com/current?access_key=#{API_KEY}&query=#{ERB::Util.url_encode(city)}"

    response = HTTParty.get(url)
    weather = response['current']
    @weather = Weather.new(weather)
  end
end
