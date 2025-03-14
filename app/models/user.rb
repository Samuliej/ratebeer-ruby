class User < ApplicationRecord
  include RatingAverage

  has_many :ratings
  has_many :beers, through: :ratings
  has_many :memberships
  has_many :beer_clubs, through: :memberships

  # Käyttäjätunnuksen täytyy olla uniikki, minimipituus 3
  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }

  def average_rating
    @ratings = ratings
    calculate_average
  end
end
