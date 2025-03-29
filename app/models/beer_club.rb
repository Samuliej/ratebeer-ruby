class BeerClub < ApplicationRecord
  MINIMUM_YEAR = 1800
  has_many :memberships
  has_many :users, through: :memberships

  validates :name, :founded, :city, presence: true
  include YearValidatable
  year_attribute :founded

  def to_s
    "#{name}, founded #{founded} in #{city}"
  end
end
