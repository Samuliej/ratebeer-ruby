class Rating < ApplicationRecord
  belongs_to :beer

  def print
    logger.info "#{beer.name} #{score}"
  end

  def to_s
    logger.info "#{beer.name} #{score}"
  end
end
