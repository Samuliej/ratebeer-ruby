class Beer < ApplicationRecord
  belongs_to :brewery
  # Merkitään ratingit riippuvaisiksi oluista
  # poistaessa oluen, poistuu myös ratingit.
  # Sain konsolista poistettua kaikki orvot kivalla onelinerilla:
  # Rating.all.select { |r| !Beer.exists?(r.beer_id) }.each { |orpo| orpo.destroy }
  has_many :ratings, dependent: :destroy

  def average_rating
    # Lasketaan oluet olion ratings olioiden
    # scorejen summa
    # Toteutin tehtävä 4:n reducella, eli
    # injectillä, joten tehdään
    # tehtävä 5 mapilla:

    # Tekee taulukon pelkistä scoreista
    scores = self.ratings.map { |rating| rating.score }

    # Lasketaan scorejen summa
    summa = scores.sum

    # Lasketaan keskiarvo sekä tiivistetään yhteen desimaaliin
    (summa / (self.ratings.count.to_f)).truncate(1)
  end

  def to_s
    "#{self.name} #{self.style}, by #{self.brewery.name}"
  end
end
