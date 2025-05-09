class Rating < ApplicationRecord
  # Reittauksen syntyessä, muuttuessa tai tuhoutuessa,
  # samalla "kosketetaan" reittaukseen liittyvää olutta
  belongs_to :beer, touch: true
  belongs_to :user

  scope :latest, -> { order(created_at: :desc).limit(5) }

  validates :score, numericality: { greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 50,
                                    only_integer: true }

  def print
    logger.info "#{beer.name} #{score}"
  end

  # Palauttaa merkkijonon jossa oluen nimi ja reittaus
  def to_s
    "#{beer.name} #{score}"
  end
end
