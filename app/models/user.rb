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
  has_many :confirmed_memberships, -> { where(confirmed: true) }, class_name: 'Membership'
  has_many :unconfirmed_memberships, -> { where(confirmed: false) }, class_name: 'Membership'
  has_many :beer_clubs, through: :memberships

  scope :most_active, ->(limit = 3) {
    select('users.*, COUNT(ratings.id) AS ratings_count')
      .joins(:ratings)
      .group('users.id')
      .order('ratings_count DESC')
      .limit(limit)
  }

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

  # Laskee käyttäjän lempioluen
  # @return Beer
  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  # Laskee käyttäjän lempiolut tyylin
  # @return String
  def favorite_style
    calculate_favorite_beer_style unless ratings.empty?
  end

  # Laskee käyttäjän suosikkipanimon
  # @return Brewery
  def favorite_brewery
    calculate_favorite_brewery unless ratings.empty?
  end

  private

  # Lasketaan käyttäjän eniten arvostelema olut, josta päätellään
  # suosikkioluen tyyli.
  # @return String
  def calculate_favorite_beer_style
    # Erottaa oluet tyylin mukaan
    styles_hash = group_ratings_by_beer_attribute(:style)
    # Summaa jokaisen tyylin oluen ratingin, sekä tekee niistä taulukollisen
    # hashmappeja, josta selviää millä tyylillä mikä yhteinen score
    styles_with_summed_ratings = sum_ratings_score_by_beer_attribute(styles_hash, :style)
    # Palautetaan näistä se tyyli, jolla summattu score on suurin
    favorite_style = styles_with_summed_ratings.max_by{ |k| k[:rating] }[:style]
    favorite_style.name
  end

  # Lasketaan käyttäjän suosikkipanimo
  # @return Brewery
  def calculate_favorite_brewery
    breweries_hash = group_ratings_by_beer_attribute(:brewery)
    breweries_with_summed_ratings = sum_ratings_score_by_beer_attribute(breweries_hash, :brewery)
    breweries_with_summed_ratings.max_by{ |k| k[:rating] }[:brewery]
  end

  # Palauttaa hashmapin Ratingeista ryhmitettynä haluaman avaimen alle
  # esim:
  # @return Hash{ String => [ Rating ] }
  # tai
  # @return Hash{ Brewery => [ Rating } }
  def group_ratings_by_beer_attribute(key)
    beer = ratings.first.beer
    ratings.group_by { |r| r.beer.send(key) } if beer.respond_to?(key)
  end

  # Laskee yhteen oluttyylien tai panimoiden arvostelupisteet annetusta hashista.
  # Toimii myös tulevaisuudessa muillakin.
  #
  # @param [Hash{String, Brewery => Array<Rating>}] hash
  #   Hash, jossa avaimina ovat joko oluttyylit (String) tai panimo-oliot (Brewery),
  #   ja arvoina ovat taulukot `Rating`-olioita, jotka sisältävät pisteet.
  # @param [Symbol] output_key
  #   Avaimen nimi, jota käytetään palautetussa hashissa (esim. `:style` tai `:brewery`).
  # @return [Array<Hash{Symbol => String, :rating => Integer}>]
  #   Taulukko hasheja, joissa on annettu avain (`output_key`) ja yhteenlasketut pisteet.
  #   Esimerkiksi:
  #   [
  #     { style: "IPA", rating: 85 },
  #     { style: "Stout", rating: 92 }
  #   ]
  #   Tai:
  #   [
  #     { brewery: <Brewery name: "Hyvä panimo" ...>, rating: 90 },
  #     { brewery: <Brewery name: "Toinen panimo" ...>, rating: 100 }
  #   ]
  def sum_ratings_score_by_beer_attribute(hash, output_key)
    hash.keys.map do |key|
      ratings = hash[key].map(&:score)
      total_rating = ratings.sum
      { output_key => key, rating: total_rating }
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
