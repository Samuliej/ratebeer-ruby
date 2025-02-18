class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings

  def average_rating
    # Lasketaan oluet olion ratings olioiden
    # scorejen summa
    summa = self.ratings.inject(0) {
      |sum, rating| sum + rating.score
    }

    # Lasketaan keskiarvo sekä tiivistetään yhteen desimaaliin
    (summa / (self.ratings.count.to_f)).truncate(1)
  end
end
