require 'rails_helper'

# Googlen rajapinta käyttää JSON formaattia, joten mockasin sitä.
# Stubattu JSON paljon yksinkertaisempaa mitä aidon pyynnön.
# Testit tarkistavat kuitenkin että tärkeimmät kentät ovat paikallaan
describe "Beermapping API" do
  API_KEY = ENV["GOOGLE_PLACES_API_KEY"].freeze

  it "when HTTP get doesn't return any entries, it should return an empty array" do
    canned_answer = <<-JSON
      {
        "results": []
      }
    JSON

    stub_request(:get, "https://maps.googleapis.com/maps/api/place/textsearch/json?key=#{API_KEY}&query=beer%20pub%20tavern%20brewery%20in%20laukaa").
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }).
      to_return(status: 200, body: canned_answer, headers: { 'Content-Type' => "application/json" })


    places = BeermappingApi.places_in("laukaa")

    expect(places.size).to eq(0)
    expect(places).to eq([])
  end

  it "when HTTP GET returns one entry, it' s parsed and returned" do
    canned_answer = <<-JSON
      {
        "results": [
          {
            "name": "Liisan Pub",
            "formatted_address": "Liepeentie 11, 41400 Lievestuore, Finland",
            "opening_hours" :
             {
                "open_now" : true
             },
            "price_level" : 2,
            "rating" : 3.9
          }
        ]
      }
    JSON

    stub_request(:get, "https://maps.googleapis.com/maps/api/place/textsearch/json?key=#{API_KEY}&query=beer%20pub%20tavern%20brewery%20in%20laukaa").
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }).
      to_return(status: 200, body: canned_answer, headers: { 'Content-Type' => "application/json" })


    places = BeermappingApi.places_in("laukaa")

    expect(places.size).to eq(1)
    place = places.first

    expect(place.name).to eq("Liisan Pub")
    expect(place.formatted_address).to eq("Liepeentie 11, 41400 Lievestuore, Finland")
    expect(place.open_now).to eq(true)
    expect(place.rating).to eq(3.9)
    expect(place.price_level).to eq(2)
  end

  it "when HTTP GET returns more than one entry, they are parsed and returned" do
    pub_names = ["Liisan Pub", "Heikin Pub", "Lassen Pub", "Lauran Pub"]
    canned_answer = <<-JSON
      {
        "results": [
          {
            "name": "Liisan Pub",
            "formatted_address": "Liepeentie 12, 41400 Lievestuore, Finland",
            "opening_hours" :
             {
                "open_now" : true
             },
            "price_level" : 2,
            "rating" : 3.9
          },
          {
            "name": "Heikin Pub",
            "formatted_address": "Liepeentie 13, 41400 Lievestuore, Finland",
            "opening_hours" :
             {
                "open_now" : true
             },
            "price_level" : 2,
            "rating" : 3.9
          },
          {
            "name": "Lassen Pub",
            "formatted_address": "Liepeentie 14, 41400 Lievestuore, Finland",
            "opening_hours" :
             {
                "open_now" : true
             },
            "price_level" : 2,
            "rating" : 3.9
          },
          {
            "name": "Lauran Pub",
            "formatted_address": "Liepeenmäki 11, 41500 Lievestuore, Finland",
            "opening_hours" :
             {
                "open_now" : true
             },
            "price_level" : 2,
            "rating" : 3.9
          }
        ]
      }
    JSON

    stub_request(:get, "https://maps.googleapis.com/maps/api/place/textsearch/json?key=#{API_KEY}&query=beer%20pub%20tavern%20brewery%20in%20laukaa").
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }).
      to_return(status: 200, body: canned_answer, headers: { 'Content-Type' => "application/json" })


    places = BeermappingApi.places_in("laukaa")

    expect(places.size).to eq(4)
    places.each do |place|
      expect(pub_names).to include(place.name)
      expect(place.open_now).to eq(true)
      expect(place.rating).to eq(3.9)
      expect(place.price_level).to eq(2)
    end
  end
end