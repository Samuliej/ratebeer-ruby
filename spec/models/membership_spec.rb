require 'rails_helper'

RSpec.describe Membership, type: :model do
  describe "with valid attributes" do
    let(:membership) { FactoryBot.create(:membership) }

    it "is created" do
      expect(membership).to be_valid
      expect(Membership.count).to eq 1
    end
  end

  describe "with invalid attributes" do
    let(:membership_without_user) { FactoryBot.build :membership, user: nil }
    let(:membership_without_beer_club) { FactoryBot.build :membership, beer_club: nil }

    it "is not created without user" do
      expect(membership_without_user).not_to be_valid
      expect(Membership.count).to eq 0
    end

    it "is not created without beer club" do
      expect(membership_without_beer_club).not_to be_valid
      expect(Membership.count).to eq 0
    end
  end
end