require "rails_helper"

include Helpers

describe "Rating Page" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "Iso 3", brewery: brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery: brewery }
  let!(:user) { FactoryBot.create :user }

  let!(:rating1) { FactoryBot.create :rating, beer: beer1, user: user }
  let!(:rating2) { FactoryBot.create :rating, beer: beer2, user: user }
  AMOUNT_OF_RATINGS = 2

  before :each do
    sign_in(username: "Pekka", password: "F00bar%")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select "Iso 3", from: "rating[beer_id]"
    fill_in "rating[score]", with: "15"

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "visiting all ratings page shows ratings in DB and the total amount of ratings" do
    visit ratings_path
    expect(page).to have_content "List of ratings"
    expect(page).to have_content "Ratings count: #{Rating.count}"
    expect(page).to have_content "Iso 3"
    expect(page).to have_content "10"
  end
end