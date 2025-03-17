require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq "Pekka"
    # Alempi ei toimi, sillä se yrittää verrata, että
    # user.username ja merkkijono "Pekka" ovat sama olio
    # expect(user.username).to be "Pekka"
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq 0
  end

  describe "with improper password" do
    let(:user1) { User.create username: "Pekka", password: "asd", password_confirmation: "asd" }
    let(:user2) { User.create username: "Pentti", password: "asdasdasd", password_confirmation: "asdasdasd" }

    it "is not saved with too short password" do
      expect(user1).not_to be_valid
      expect(User.count).to eq 0
    end

    it "is not saved with too weak password" do
      expect(user2).not_to be_valid
      expect(User.count).to eq 0
    end
  end

  describe "with a proper password" do
    # Let metodin jälkeen user muuttujaan voidaan viitata normaalisti describe
    # lohkon sisällä
    let(:user) { FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq 1
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq 2
      expect(user.average_rating).to eq 15.0
    end
  end

  describe "favorite beer" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining the favorite_beer" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq nil
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating( { user: user }, 20)

      expect(user.favorite_beer).to eq beer
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({user: user}, 10, 20, 15)
      best = create_beer_with_rating({ user: user }, 25 )


      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining the favorite_style" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have a favorite style" do
      expect(user.favorite_style).to eq nil
    end

    it "is the style of the only rated if only one rating" do
      beer = create_beer_with_rating( { user: user }, 20)

      expect(user.favorite_style).to eq beer.style
    end

    it "is the style of the one with overall highest rating if several rated" do
      best_style = "style2"

      create_beers_with_many_ratings_and_custom_styles({ user: user }, 10, 20, 30, "style1")
      create_beers_with_many_ratings_and_custom_styles({ user: user }, 20, 30, 40, best_style)

      expect(user.favorite_style).to eq best_style
    end
  end

  describe "favorite brewery" do
    let(:user) { FactoryBot.create(:user) }
    let(:brewery) { FactoryBot.create(:brewery, name: "Awesome brewery") }
    let(:brewery2) { FactoryBot.create(:brewery, name: "Not so awesome brewery") }
    let(:brewery3) { FactoryBot.create(:brewery, name: "Adequate brewery") }
    let(:brewery4) { FactoryBot.create(:brewery, name: "just another brewery") }

    it "has method for determining the favorite_brewery" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have a favorite brewery" do
      expect(user.favorite_brewery).to eq nil
    end

    it "is the brewery of the only rated beer if only one rating" do
      beer = create_beer_under_specified_brewery_with_rating({ user: user }, 20, "Lager", brewery)

      expect(user.favorite_brewery.name).to eq beer.brewery.name
    end

    it "is the brewery of the beer/beers with overall highest rating if several rated" do
      best_brewery = brewery

      create_beers_under_specified_brewery_with_rating({ user: user }, 10, 15, 10, 22, 43, "Lager", brewery2)
      create_beers_under_specified_brewery_with_rating( { user: user }, 10, 10, 5, 3, 2, 5, 10, "IPA", brewery4)
      create_beers_under_specified_brewery_with_rating({ user: user }, 40, 45, 10, 22, 43, "Lager", brewery)
      create_beers_under_specified_brewery_with_rating({ user: user }, 40, 45, 10, 22, 42, "Lager", brewery3)

      expect(user.favorite_brewery.name).to eq best_brewery.name
    end
  end
end

def create_beer_with_rating(object, score, style = "teststyle")
  beer = FactoryBot.create(:beer, style: style)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
  beer
end

def create_beer_under_specified_brewery_with_rating(object, score, style, brewery)
  beer = FactoryBot.create(:beer, style: style, brewery: brewery)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
  beer
end

def create_beers_under_specified_brewery_with_rating(object, *scores, style, brewery)
  scores.each do |score|
    create_beer_under_specified_brewery_with_rating(object, score, style, brewery)
  end
end

# Rubyssa *scores * on splat operator, sallii metodin
# ottaa vastaan vaihtelevan määrän argumentteja taulukkona
def create_beers_with_many_ratings(object, *scores)
  scores.each do  |score|
    create_beer_with_rating(object, score)
  end
end

def create_beers_with_many_ratings_and_custom_styles(object, *scores, style)
  scores.each do  |score|
    create_beer_with_rating(object, score, style)
  end
end