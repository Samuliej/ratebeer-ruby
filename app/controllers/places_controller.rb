require "ostruct"

class PlacesController < ApplicationController
  def index
  end

  def show
    last_places = session[:last_places]
    @place = last_places.find { |e| e.place_id == params[:id] }
  end

  def search
    @city = format_city_name(params[:city])
    @places = BeermappingApi.places_in(@city)
    @weather = WeatherApi.fetch_weather(@city)
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      session[:last_places] = @places
      render :index, status: 418
    end
  end

  private

  def format_city_name(city)
    city.downcase.split.map(&:capitalize).join(" ")
  end
end
