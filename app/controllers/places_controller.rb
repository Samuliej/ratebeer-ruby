require "ostruct"

class PlacesController < ApplicationController
  API_KEY = ENV['GOOGLE_PLACES_API_KEY'].freeze
  RADIUS = 6000
  def index
  end

  def search
    @city = format_city_name(params[:city])
    @places = BeermappingApi.places_in(@city)
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index, status: 418
    end
  end

  private

  def format_city_name(city)
    city.downcase.split.map(&:capitalize).join(" ")
  end
end
