class User < ApplicationRecord
  has_many :ratings

  include RatingAverage

  def average_rating
    @ratings = ratings
    calculate_average
  end
end
