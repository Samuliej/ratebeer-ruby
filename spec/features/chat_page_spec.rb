require 'rails_helper'
include Helpers

describe "Chat", type: :feature do
  let!(:user1) { FactoryBot.create(:user, username: "Pekka") }
  let!(:user2) { FactoryBot.create(:user, username: "Liisa") }

  context "when user is not signed in" do
    it "does not show Chat link in navbar" do
      visit root_path
      expect(page).not_to have_link("Chat")
    end

    it "redirects to login page when accessing /chat" do
      visit chat_path
      expect(current_path).to eq(new_session_path)
      expect(page).to have_content("Please sign in")
    end
  end

  context "when user is signed in" do
    before do
      sign_in(username: "Pekka", password: "F00bar%")
    end

    it "shows Chat link in navbar" do
      visit root_path
      expect(page).to have_link("Chat")
    end

    it "can send messages and they are visible" do
      visit chat_path

      expect(page).not_to have_selector(".chat-message")

      fill_in "chat_message_content", with: "Hei vaan"
      click_button "Send"

      expect(page).to have_content("Hei vaan")
      expect(page).to have_selector(".chat-message", count: 1)

      fill_in "chat_message_content", with: "Toinen viesti"
      click_button "Send"

      expect(page).to have_content("Toinen viesti")
      expect(page).to have_selector(".chat-message", count: 2)
    end

    it "sent messages are visible to other users" do
      visit chat_path

      fill_in "chat_message_content", with: "Yhteinen viesti"
      click_button "Send"

      sign_out("Pekka")
      sign_in(username: "Liisa", password: "F00bar%")
      visit chat_path

      expect(page).to have_content("Yhteinen viesti")

      fill_in "chat_message_content", with: "Vastaus viestiin"
      click_button "Send"

      expect(page).to have_content("Vastaus viestiin")
    end
  end
end
