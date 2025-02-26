class Brewery < ApplicationRecord
  has_many :beers, dependent: :destroy
  # Asetetaan assosiaatio ratingeille oluiden kautta
  has_many :ratings, through: :beers
  include RatingAverage

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    # Kutsuu olion omaa year metodia
    self.year = 2022
    puts "changed year to #{year}"
  end

  def average_rating
    @ratings = self.ratings
    calculate_average
  end


  # Defaultit getterit ja setterit näyttävät
  # suurinpiirtein tältä
  # def year
  #   read_attribute(:year)
  # end
  #
  # def year=(value)
  #   write_attribute(:year, value)
  # end
end
