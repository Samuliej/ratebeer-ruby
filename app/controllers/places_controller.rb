require "ostruct"

class PlacesController < ApplicationController
  API_KEY = ENV['GOOGLE_PLACES_API_KEY'].freeze
  RADIUS = 6000
  def index
  end

  def search
    coords = get_city_coordinates(params[:city])

    if coords.no_results || coords.invalid_request
      redirect_to places_path, notice: coords.no_results ? "No places found in #{params[:city]}" : "Invalid request" and return
    end

    url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{coords.lat},#{coords.lng}&radius=#{RADIUS}&type=bar&key=#{API_KEY}"

    places = fetch_places(url)

    if places.empty?
      redirect_to places_path, notice: "No places found in #{params[:city]}"
      return
    end

    @places = places.map do |place|
      place_obj = Place.new(place)
      place_obj
    end

    render :index, status: 418
  end

  def fetch_places(url)
    places = []
    loop do
      response = HTTParty.get(url)
      places += response["results"]

      break unless response["next_page_token"]

      sleep(2)  # Allow time for the next page to be available
      url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken=#{response["next_page_token"]}&key=#{API_KEY}"
    end
    places.uniq{ |place| place['name'] }
  end

  def get_city_coordinates(city_name)
    url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{ERB::Util.url_encode(city_name)}&key=#{API_KEY}"
    response = HTTParty.get url
    coords = OpenStruct.new

    case response["status"]
    when "ZERO_RESULTS"
      coords.no_results = true
      coords
    when "INVALID_REQUEST"
      coords.invalid_request = true
      coords
    else
      coords = build_coordinates(response, coords)
    end
    coords
  end

  def build_coordinates(response, coords)
    lat = response['results'][0]['geometry']['location']['lat']
    lng = response['results'][0]['geometry']['location']['lng']

    coords.lat = lat
    coords.lng = lng

    coords
  end
end
