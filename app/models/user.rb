class User < ApplicationRecord
  include RatingAverage

  MINIMUM_PASSWORD_LENGTH = 4
  PASSWORD_FORMAT = /\A
    (?=.{4,})          # 4 kirjainta tai enemmän
    (?=.*\d)           # Yksi numero
    (?=.*[A-Z])        # Sisältää ainakin yhden ison kirjaimen
    (?=.*[[:^alnum:]]) # Sisältää symbolin
  /x

  # Lisää oliolle attribuutit password ja password_confirmation
  # Tallentaessa oliota tietokantaan luodaan näistä password_digest
  # joka tallennetaan tietokantaan
  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  # Käyttäjätunnuksen täytyy olla uniikki, minimipituus 3
  validates :username,
            uniqueness: true,
            length: { minimum: 3, maximum: 30 },
            presence: true

  validates :password, presence: true
  validate :validate_password

  def average_rating
    @ratings = ratings
    calculate_average
  end

  private

  def validate_password
    if password.nil? || password.empty?
      errors.add(:password, "can't be empty")
      return false
    end

    if password.length < MINIMUM_PASSWORD_LENGTH
      errors.add(:password, " must be #{MINIMUM_PASSWORD_LENGTH} characters or more.")
    end

    return if password.match PASSWORD_FORMAT

    errors.add(:password, " must contain one number, one upper-case character and one symbol.")
  end
end
