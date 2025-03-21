require "rails_helper"

include Helpers

describe "Beers page" do
  it "should not have any before been created" do
    visit beers_path
    expect(page).to have_content "Beers"
    expect(page).to have_content "Number of beers: 0"
    expect(page).to have_content "New beer"
    save_page
  end

  describe "when beers exist" do
    before :each do
      @brewery = FactoryBot.create(:brewery, name: "Koff")
      @beers = ["Iso 3", "Karhu", "Koff"]
      @beers.each do |beer|
        FactoryBot.create(:beer, name: beer, style: "Lager", brewery: @brewery)
      end

      visit beers_path
    end

    it "lists the existing beers and their total number" do
      expect(page).to have_content "Number of beers: #{@beers.count}"
      @beers.each do |beer_name|
        expect(page).to have_content beer_name
      end
    end

    it "allows user to navigate to page of a Beer" do
      click_link "Karhu"

      expect(page).to have_content "Karhu"
      expect(page).to have_content "Style: Lager"
      expect(page).to have_content "Brewery: Koff"
    end

  end


  describe "beer can be added" do
    before :each do
      @brewery = FactoryBot.create(:brewery, name: "Koff")
      visit beers_path
      click_link "New beer"
    end

    it "user can navigate to the add beer page" do
      expect(page).to have_content "New beer"
      expect(page).to have_content "Style"
    end

    it "when beer name is valid, beer is added to the system" do
      fill_in "beer_name", with: "Iso 3"
      select "Lager", from: "beer[style]"
      select "Koff", from: "beer[brewery_id]"

      expect{
        click_button "Create Beer"
      }.to change{Beer.count}.from(0).to(1)

      expect(current_path).to eq beers_path
      expect(page).to have_content "Beer was successfully created."
    end

    it "when beer name is invalid, beer is not added to the system and nothing gets stored to the DB" do
      fill_in "beer_name", with: ""
      select "Lager", from: "beer[style]"
      select "Koff", from: "beer[brewery_id]"

      click_button "Create Beer"

      expect(Beer.count).to eq 0
      expect(page).to have_content "1 error prohibited this beer from being saved:"
      expect(page).to have_content "Name can't be blank"
    end
  end
end