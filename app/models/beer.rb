class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery
  # Merkitään ratingit riippuvaisiksi oluista
  # poistaessa oluen, poistuu myös ratingit.
  # Sain konsolista poistettua kaikki orvot kivalla onelinerilla:
  # Rating.all.select { |r| !Beer.exists?(r.beer_id) }.each { |orpo| orpo.destroy }
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user
  # Jos haluttaisiin palauttaa vain yksittäinen käyttäjä
  # has_many :raters, -> { distinct }, through: :ratings, source: :user
  belongs_to :style

  validates :name, presence: true
  validates :style, presence: true
  validates :brewery_id, presence: true

  def average_rating
    @ratings = ratings
    calculate_average
  end

  def average
    return 0 if ratings.empty?

    ratings.sum(&:score) / ratings.count.to_f
  end

  def to_s
    "#{name} #{style.name}, by #{brewery.name}"
  end
end
