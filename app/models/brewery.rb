class Brewery < ApplicationRecord
  extend Top

  MINIMUM_YEAR = 1040

  has_many :beers, dependent: :destroy
  # Asetetaan assosiaatio ratingeille oluiden kautta
  has_many :ratings, through: :beers
  include RatingAverage
  include YearValidatable
  year_attribute :year

  validates :name, presence: true
  validates :year, presence: true
  validate :validate_year

  scope :active, -> { where(active: true) }
  scope :retired, -> { where(active: [nil, false]) }

  def print_report
    config.logger name
    config.logger "established at year #{year}"
    config.logger "number of beers #{beers.count}"
  end

  def restart
    # Kutsuu olion omaa year metodia
    self.year = 2022
    config.logger "changed year to #{year}"
  end

  def average_rating
    @ratings = ratings
    calculate_average
  end

  after_create_commit do
    status = ""
    target_id = ""
    if active
      target_id = "active_brewery_rows"
      status = "active"
    else
      target_id = "retired_brewery_rows"
      status = "retired"
    end

    # Broadcast an append action to the breweries_index channel
    broadcast_append_to "breweries_index", partial: "breweries/brewery_row", target: target_id
    broadcast_replace_to "breweries_index", partial: "breweries/brewery_count", locals: { status: status }, target: "#{status}_brewery_count"
  end

  after_destroy_commit do
    status = active ? "active" : "retired"
    broadcast_remove_to "breweries_index", target: self
    broadcast_replace_to "breweries_index", partial: "breweries/brewery_count", locals: { status: status }, target: "#{status}_brewery_count"
  end
end
