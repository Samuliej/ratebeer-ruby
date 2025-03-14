require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "visiting the index" do
    visit users_url
    assert_selector "h1", text: "Users"
  end

  test "should create a new user" do
    unique_username = "UniikkiNimi"
    password = "P4s$"
    visit users_url
    click_on "New user"

    fill_in "Username", with: unique_username
    fill_in "Password", with: password
    fill_in "Password confirmation", with: password

    click_on "Create User"

    assert_text "User was successfully created"
    click_on "Back"
  end

  # test "should update User" do
  #   new_password = "N€wPassw0rd"
  #
  #   visit user_url(@user)
  #   click_on "Edit this user", match: :first
  #
  #   fill_in "Username", with: @user.username
  #   fill_in "Password",	with: new_password
  #   fill_in "Password confirmation",	with: new_password
  #
  #   click_on "Update User"
  #
  #   assert_text "User was successfully updated"
  #   click_on "Back"
  # end

  # test "should destroy User" do
  #   visit user_url(@user)
  #   click_on "Destroy this user", match: :first
  #
  #   assert_text "User was successfully destroyed"
  # end
end
