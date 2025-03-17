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

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    calculate_best_rated_beer_style unless ratings.empty?
  end

  private

  # Lasketaan käyttäjän eniten arvostelema olut, josta päätellään
  # suosikkioluen tyyli.
  # @return String
  def calculate_best_rated_beer_style
    # Erottaa oluet tyylin mukaan
    styles_hash = group_ratings_by_style
    # Summaa jokaisen tyylin oluen ratingin, sekä tekee niistä taulukollisen
    # hashmappeja, josta selviää millä tyylillä mikä yhteinen score
    styles_with_summed_ratings = sum_style_ratings(styles_hash)
    # Palautetaan näistä se tyyli, jolla summattu score on suurin
    styles_with_summed_ratings.max_by{ |k| k[:rating] }[:style]
  end

  # Palauttaa hashmapin Ratingeista ryhmitettynä tyylin alle
  # @return Hash{ String => Rating }
  def group_ratings_by_style
    ratings.group_by { |r| r.beer.style }
  end

  # @param [Hash{String => Rating}] styles_hash Hash, jossa avaimina ovat oluttyylit
  #   (esim. "IPA", "Stout") ja arvoina `Rating`-oliot, jotka sisältävät oluen arvostelut.
  # @return [Hash{String => Integer}] Hash, jossa avaimina ovat oluttyylit ja arvoina niiden kokonaisratingit.
  #   Esim: { "IPA" => 85, "Stout" => 92 }

  def sum_style_ratings(styles_hash)
    styles_hash.keys.map do |key|
      ratings = styles_hash[key].map(&:score)
      total_rating = ratings.sum
      { style: key, rating: total_rating }
    end
  end

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
