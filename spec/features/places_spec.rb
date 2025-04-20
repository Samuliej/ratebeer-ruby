require 'rails_helper'

describe "Places" do
  let(:weather) {
    Weather.new(
      temperature: 7,
      weather_icons: [],
      weather_descriptions: ["Cloudy", "With a chance of meatballs"],
      wind_speed: 5,
      wind_dir: "E"
  )}

  describe "beer places are found" do
    it "if one is returned by the API, it is shown at the page" do
      allow(BeermappingApi).to receive(:places_in).with("Kumpula").and_return(
        [ Place.new( name: "Oljenkorsi", place_id: 1 ) ]
      )
      allow(WeatherApi).to receive(:fetch_weather).with("Kumpula").and_return(
        weather
      )

      visit places_path
      fill_in "city", with: 'Kumpula'
      click_button "Search"

      expect(page).to have_content "Oljenkorsi"
    end

    it "if several are returned by the API, they are shown on the page" do
      place_names = %w[Oljenkorsi Koljenorsi Noljenkorsi Asd]
      id = 1
      allow(BeermappingApi).to receive(:places_in).with("Kumpula").and_return(
        place_names.map do |place_name|
          place = Place.new( name: place_name, place_id: id )
          id += 1
          place
        end
      )
      allow(WeatherApi).to receive(:fetch_weather).with("Kumpula").and_return(
        weather
      )


      visit places_path
      fill_in "city", with: "Kumpula"
      click_button "Search"

      place_names.each{ |place_name| expect(page).to have_content(place_name) }
    end
  end

  describe "when beer places are not found" do

    it "shows default text" do
      allow(BeermappingApi).to receive(:places_in).with("Kumpula").and_return(
        []
      )
      allow(WeatherApi).to receive(:fetch_weather).with("Kumpula").and_return(
        weather
      )

      visit places_path
      fill_in "city", with: "Kumpula"
      click_button "Search"

      expect(page).to have_content "No locations in Kumpula"
    end
  end

end