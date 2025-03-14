class Brewery < ApplicationRecord
  MINIMUM_YEAR = 1040

  has_many :beers, dependent: :destroy
  # Asetetaan assosiaatio ratingeille oluiden kautta
  has_many :ratings, through: :beers
  include RatingAverage

  validates :name, presence: true
  validates :year, presence: true
  validate :validate_year
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

  private

  def validate_year
    return if year.blank?

    if year < MINIMUM_YEAR
      errors.add(:year, " can't be smaller than #{MINIMUM_YEAR}")
    end

    return unless year > Time.now.year

    errors.add(:year, " can't be greater than current year")
  end
end
