require "rails_helper"

include Helpers

describe "Membership page" do
  let!(:beer_club) { FactoryBot.create :beer_club }
  let!(:user) { FactoryBot.create :user }

  # Refaktoroitu membership testit, sillä poistin linkin,
  # jolla pääsee valitsemaan droppivalikosta clubin mihin liittyä

  describe "user signed in" do
    before :each do
      sign_in(username: "Pekka", password: "F00bar%")
      visit new_membership_path
    end

    it "signed in user can navigate to join club page" do
      expect(page).to have_content "Join a Beer Club"
    end

    it "signed in user can join a beer club" do
      select "#{beer_club.name}, founded #{beer_club.founded} in #{beer_club.city}", from: "membership[beer_club_id]"
      expect { click_button "Join beer club" }.to change { Membership.count }.by(1)

      expect(current_path).to eq beer_club_path(beer_club)
      expect(page).to have_content "Welcome to the club #{user.username}"
      expect(page).to have_content "#{beer_club.name}"
      expect(page).to have_content "Members"
    end
  end
end