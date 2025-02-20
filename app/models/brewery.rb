class Brewery < ApplicationRecord
  has_many :beers, dependent: :destroy
  # Asetetaan assosiaatio ratingeille oluiden kautta
  has_many :ratings, through: :beers

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
    all_ratings = self.ratings.map { |rating| rating.score }
    all_score_sum = all_ratings.inject(:+)

    all_score_sum / all_ratings.size
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
