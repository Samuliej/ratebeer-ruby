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
    let(:user) { User.create username: "Pekka", password: "S€cr3t", password_confirmation: "S€cr3t" }
    let(:test_brewery) { Brewery.new name: "Test Brewery", year: 2000 }
    let(:test_beer) { Beer.create name: "Test Beer", style: "Test Style", brewery: test_brewery }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq 1
    end

    it "and with two ratings, has the correct average rating" do
      rating = Rating.new score: 10, beer: test_beer
      rating2 = Rating.new score: 20, beer: test_beer

      user.ratings << rating
      user.ratings << rating2

      expect(user.ratings.count).to eq 2
      expect(user.average_rating).to eq 15.0
    end
  end
end
