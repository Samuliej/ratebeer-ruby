class Brewery < ApplicationRecord
  has_many :beers, dependent: :destroy
  # Asetetaan assosiaatio ratingeille oluiden kautta
  has_many :ratings, through: :beers
  include RatingAverage

  validates :name, presence: true
  validates :year, presence: true, numericality: { greater_than_or_equal_to: 1040,
                                                   less_than_or_equal_to: 2022,
                                                   only_integer: true }

  def print_report
    config.logger name
    config.logger "established at year #{year}"
    config.logger "number of beers #{beers.count}"
  end

  def restart
    # Kutsuu olion omaa year metodia
    self.year = 2022
    config.logger "changed year to #{year}"
  end

  def average_rating
    @ratings = ratings
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
