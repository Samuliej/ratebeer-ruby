require "rails_helper"

include Helpers

describe "Users page" do
  before :each do
    @user = FactoryBot.create(:user)
  end

  describe "who has signed up" do
    it "can sign in with right credentials" do
      sign_in username: "Pekka", password: "F00bar%"

      expect(page).to have_content "Welcome back!"
      expect(page).to have_content "Pekka"
    end

    it "is redirected back to sign in form if wrong credentials" do
      visit new_session_path
      fill_in "username", with: "Pekka"
      fill_in "password", with: "safadfsa"
      click_button "Log in"

      expect(current_path).to eq new_session_path
      expect(page).to have_content "Username and/or password mismatch"
    end

    describe "who has made ratings" do
      let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
      let!(:brewery2) { FactoryBot.create :brewery, name: "Brewery" }
      let!(:beer1) { FactoryBot.create :beer, name: "Iso 3", style: "Lager", brewery: brewery }
      let!(:beer2) { FactoryBot.create :beer, name: "Karhu", style: "Lager", brewery: brewery }
      let!(:beer3) { FactoryBot.create :beer, name: "Kalia", style: "IPA", brewery: brewery2 }
      let!(:user) { FactoryBot.create :user, username: "Ukko" }

      let!(:rating1) { FactoryBot.create :rating, beer: beer1, user: user }
      let!(:rating2) { FactoryBot.create :rating, beer: beer2, user: user }
      let!(:rating2) { FactoryBot.create :rating, beer: beer3, user: user }

      it "can see his favorite style" do
        sign_in username: "Ukko", password: "F00bar%"
        visit user_path(user)
        expect(page).to have_content "#{user.username}'s favorite beer style is Lager"
      end

      it "can see his favorite brewery" do
        sign_in username: "Ukko", password: "F00bar%"
        visit user_path(user)
        expect(page).to have_content "#{user.username}'s favorite brewery is Koff"
      end

    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in "user_username", with: "Brian"
    fill_in "user_password", with: "F00bar%"
    fill_in "user_password_confirmation", with: "F00bar%"

    # Testataan operaation vaikutusta sovelluksen olion arvoon,
    # välitetään suoritettava operaatio koodilohkona expect:ille
    expect{
      click_button("Create User").to change{User.count}.by(1).by(1)
    }
  end
end