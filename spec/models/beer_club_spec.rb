require 'rails_helper'

RSpec.describe BeerClub, type: :model do
  describe "with valid attributes" do
    let(:beer_club) { FactoryBot.create :beer_club }

    it "is created with valid attributes" do
      expect(beer_club).to be_valid
      expect(BeerClub.count).to eq(1)
    end
  end

  describe "with invalid attributes" do
    let(:beer_club_without_name)           { FactoryBot.build(:beer_club, name: nil) }
    let(:beer_club_without_founded)        { FactoryBot.build(:beer_club, founded: nil) }
    let(:beer_club_without_city)           { FactoryBot.build(:beer_club, city: nil) }
    let(:beer_club_without_any_attributes) { FactoryBot.build(:beer_club, name: nil, founded: nil, city: nil) }


    it "is not created without name" do
      expect(beer_club_without_name).not_to be_valid
      expect(BeerClub.count).to eq(0)
    end

    it "is not created without founded" do
      expect(beer_club_without_founded).not_to be_valid
      expect(BeerClub.count).to eq(0)
    end

    it "is not created without city" do
      expect(beer_club_without_city).not_to be_valid
      expect(BeerClub.count).to eq(0)
    end

    it "is not created without any attributes" do
      expect(beer_club_without_any_attributes).not_to be_valid
      expect(BeerClub.count).to eq(0)
    end

    it "gives errors if beer club is not valid" do
      expect(beer_club_without_name).not_to be_valid
      expect(beer_club_without_name.errors[:name]).to include("can't be blank")

      expect(beer_club_without_founded).not_to be_valid
      expect(beer_club_without_founded.errors[:founded]).to include("can't be blank")

      expect(beer_club_without_city).not_to be_valid
      expect(beer_club_without_city.errors[:city]).to include("can't be blank")

      expect(beer_club_without_any_attributes).not_to be_valid
      expect(beer_club_without_any_attributes.errors[:name]).to include("can't be blank")
      expect(beer_club_without_any_attributes.errors[:founded]).to include("can't be blank")
      expect(beer_club_without_any_attributes.errors[:city]).to include("can't be blank")
    end
  end
end
