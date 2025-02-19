require "application_system_test_case"

class BeersTest < ApplicationSystemTestCase
  setup do
    @beer = beers(:one)
    @secondBeer = beers(:two)
  end

  test "visiting the index" do
    visit beers_url
    assert_selector "h1", text: "Beers"
  end

  test "should create beer" do
    visit beers_url
    click_on "New beer"

    fill_in "Name", with: @beer.name
    select @beer.brewery.name, from: "Brewery"
    select @beer.style, from: "Style"
    click_on "Create Beer"

    assert_text "Beer was successfully created"
    assert_current_path beers_path
  end

  test "should update Beer" do
    visit beer_url(@beer)
    click_on "Edit this beer", match: :first

    fill_in "Name", with: @secondBeer.name
    select @beer.brewery.name, from: "Brewery"
    select @secondBeer.style, from: "Style"
    click_on "Update Beer"

    assert_text "Beer was successfully updated"
    assert_current_path beer_path(@beer)
  end

  test "should destroy Beer" do
    visit beer_url(@beer)
    click_on "Destroy this beer", match: :first

    assert_text "Beer was successfully destroyed"
  end
end
