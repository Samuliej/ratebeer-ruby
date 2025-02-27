class Rating < ApplicationRecord
  belongs_to :beer

  def print
    logger.info "#{beer.name} #{score}"
  end

  # Palauttaa merkkijonon jossa oluen nimi ja reittaus
  def to_s
    "#{beer.name} #{score}"
  end
end
