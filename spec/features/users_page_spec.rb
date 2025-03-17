require "rails_helper"

include Helpers

describe "Users page" do
  before :each do
    FactoryBot.create :user
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