class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :beer_club
  scope :unconfirmed, -> { where(confirmed: false) }
end
