class Style < ApplicationRecord
  include RatingAverage
  has_many :beers
  has_many :ratings, through: :beers

  def average_rating
    @ratings = beers.map(&:ratings).flatten
    calculate_average
  end
end
