require "rails_helper"

include Helpers

describe "Rating Page" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "Iso 3", brewery: brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery: brewery }
  let!(:beer3) { FactoryBot.create :beer, name: "Kalia", brewery: brewery }
  let!(:user) { FactoryBot.create :user }
  let!(:user2) { FactoryBot.create :user, username: "EiPekka"}

  let!(:rating1) { FactoryBot.create :rating, beer: beer1, user: user }
  let!(:rating2) { FactoryBot.create :rating, beer: beer2, user: user }
  let!(:rating3) { FactoryBot.create :rating, beer: beer3, user: user2 }

  before :each do
    # Kirjoitetaan ensin cacheen että on mitään näytettävää
    Rails.cache.write("beer_top_3", Beer.top(3))
    Rails.cache.write("brewery_top_3", Brewery.top(3))
    Rails.cache.write("style_top_3", Style.top(3))

    sign_in(username: "Pekka", password: "F00bar%")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select "Iso 3", from: "rating[beer_id]"
    fill_in "rating[score]", with: "15"

    user_rating_count_before_addition = user.ratings.count
    beer1_rating_count_before_addition = beer1.ratings.count

    expect { click_button "Create Rating" }.to change { Rating.count }.by(1)

    # Checking that the user and beer ratings are updated
    expect(user.ratings.count).to eq(user_rating_count_before_addition + 1)
    expect(beer1.ratings.count).to eq(beer1_rating_count_before_addition + 1)
    expect(beer1.average_rating).to eq(12.5)
  end


  it "visiting all ratings page shows ratings in DB and the total amount of ratings" do
    visit ratings_path
    expect(page).to have_content "Ratings"
    expect(page).to have_content "Ratings count: #{Rating.count}"
    expect(page).to have_content beer1.name
    expect(page).to have_content beer2.name
    expect(page).to have_content beer3.name
    expect(page).to have_content "10"
  end

  it "visiting user's page shows the current user's created ratings and not any other ratings" do
    visit user_path(user)

    expect(page).to have_content user.username
    expect(page).to have_content "Has made #{Rating.count-1} ratings"
    expect(page).to have_content "Ratings"
    expect(page).to have_content beer1.name
    expect(page).to have_content beer2.name

    expect(page).not_to have_content beer3.name
  end
end