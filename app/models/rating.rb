class Rating < ApplicationRecord
  belongs_to :beer

  def print
    puts "#{self.beer.name} #{self.score}"
  end

  def to_s
    "#{self.beer.name} #{self.score}"
  end
end
