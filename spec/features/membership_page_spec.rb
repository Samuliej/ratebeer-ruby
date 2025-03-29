require "rails_helper"

include Helpers

describe "Membership page" do
  let!(:beer_club) { FactoryBot.create :beer_club }
  let!(:user) { FactoryBot.create :user }

  describe "no user signed in" do
    it "doesn't show option to join club" do
      visit "/"

      expect(page).not_to have_content "Join a club"
    end
  end

  describe "user signed in" do
    before :each do
      sign_in(username: "Pekka", password: "F00bar%")
      click_link "Join a club"
    end

    it "signed in user can navigate to join club page" do
      expect(page).to have_content "Join a Beer Club"
    end

    it "signed in user can join a beer club" do
      select "#{beer_club.name}, founded #{beer_club.founded} in #{beer_club.city}", from: "membership[beer_club_id]"
      expect { click_button "Join beer club" }.to change { Membership.count }.by(1)

      membership = Membership.last
      expect(current_path).to eq membership_path(membership)
      expect(page).to have_content "Membership was successfully created."
      expect(page).to have_content "Membership to #{beer_club.name}"
      expect(page).to have_content "User: #{user.username}"
    end
  end
end