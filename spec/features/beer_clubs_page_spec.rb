require "rails_helper"

describe "Beer Clubs page" do
  it "should not have any before been created" do
    visit beer_clubs_path
    expect(page).to have_selector("table tbody tr", count: 0)
  end

  describe "when beer clubs exist" do
    before :each do
      @beer_clubs = %w[ club1 club2 club3 ]
      founded = 1956
      city = "City"
      @beer_clubs.each do |beer_club|
        FactoryBot.create(:beer_club, name: beer_club, founded: founded, city: city)
      end

      visit beer_clubs_path
    end

    it "lists the existing beer clubs" do
      @beer_clubs.each do |beer_club|
        expect(page).to have_content beer_club
      end
    end

    it "allows user to navigate to page of a beer club" do
      click_link "club1"
      expect(page).to have_content "club1"
      expect(page).to have_content 1956
      expect(page).to have_content "City"
    end

    describe "when user has joined a beer club" do
      let!(:user) { FactoryBot.create :user }
      let!(:membership) { FactoryBot.create :membership, beer_club: BeerClub.first, user: user }

      it "beer clubs show the users who have joined the club" do
        click_link "club1"

        expect(page).to have_content "club1"
        expect(page).to have_content "Members"
        expect(page).to have_content "#{user.username}"
      end
    end


  end
end