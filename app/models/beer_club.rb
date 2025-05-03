class BeerClub < ApplicationRecord
  MINIMUM_YEAR = 1800
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  has_many :confirmed_memberships, -> { where(confirmed: true) }, class_name: 'Membership'
  has_many :confirmed_users, through: :confirmed_memberships, source: :user

  has_many :unconfirmed_memberships, -> { where(confirmed: false) }, class_name: 'Membership'
  has_many :unconfirmed_users, through: :unconfirmed_memberships, source: :user

  validates :name, :founded, :city, presence: true
  include YearValidatable
  year_attribute :founded

  def to_s
    "#{name}, founded #{founded} in #{city}"
  end
end
