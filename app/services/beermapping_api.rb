require "securerandom"

class BeermappingApi
  API_KEY = ENV['GOOGLE_PLACES_API_KEY'].freeze

  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_in: 1.hour) { fetch_places(city) }
  end

  def self.fetch_places(city)
    url = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=beer+pub+tavern+brewery+in+#{ERB::Util.url_encode(city)}&key=#{API_KEY}"

    places = []
    response = HTTParty.get(url)
    places += response["results"]

    # Fetch more pages if available
    while response["next_page_token"]
      sleep(2)
      next_url = "#{url}&pagetoken=#{response['next_page_token']}"
      response = HTTParty.get(next_url)
      places += response["results"]
    end

    @places = places.map do |place|
      Place.new(place)
    end

    @places
  end
end
