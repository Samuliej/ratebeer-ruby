class Beer < ApplicationRecord
  belongs_to :brewery
  # Merkitään ratingit riippuvaisiksi oluista
  # poistaessa oluen, poistuu myös ratingit.
  # Sain konsolista poistettua kaikki orvot kivalla onelinerilla:
  # Rating.all.select { |r| !Beer.exists?(r.beer_id) }.each { |orpo| orpo.destroy }
  has_many :ratings, dependent: :destroy
  include RatingAverage

  def average_rating
    @ratings = ratings
    calculate_average
  end

  def average
    return 0 if ratings.empty?

    ratings.sum(&:score) / ratings.count.to_f
  end

  def to_s
    "#{name} #{style}, by #{brewery.name}"
  end
end
