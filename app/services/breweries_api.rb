require "ostruct"

class BreweriesApi
  def self.fetch_breweries
    # avoin api ei toiminut jotein turvauduin tällaiseen ratkaisuun
    url = "https://api.openbrewerydb.org/v1/breweries?by_country=england"

    response = HTTParty.get(url)
    response.map do |r|
      { name: r["name"], year: get_random_year }
    end
  end

  # Tämä rajapinta ei antanut minkäänlaista aikaleimaa, joten satunnaisella vuodella mennään
  def self.get_random_year
    rand(1040...2025)
  end
end
