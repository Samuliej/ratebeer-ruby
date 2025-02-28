class User < ApplicationRecord
  has_many :ratings

  include RatingAverage

  # Käyttäjätunnuksen täytyy olla uniikki, minimipituus 3
  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }

  def average_rating
    @ratings = ratings
    calculate_average
  end
end
