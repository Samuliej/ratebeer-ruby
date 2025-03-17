module Helpers
  def sign_in(credentials)
    visit new_session_path
    fill_in "username", with: credentials[:username]
    fill_in "password", with: credentials[:password]
    click_button "Log in"
  end

  def create_beer_with_rating(object, score, style = "teststyle")
    beer = FactoryBot.create(:beer, style: style)
    FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
    beer
  end

  def create_beer_under_specified_brewery_with_rating(object, score, style, brewery)
    beer = FactoryBot.create(:beer, style: style, brewery: brewery)
    FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
    beer
  end

  def create_beers_under_specified_brewery_with_rating(object, *scores, style, brewery)
    scores.each do |score|
      create_beer_under_specified_brewery_with_rating(object, score, style, brewery)
    end
  end

  # Rubyssa *scores * on splat operator, sallii metodin
  # ottaa vastaan vaihtelevan määrän argumentteja taulukkona
  def create_beers_with_many_ratings(object, *scores)
    scores.each do  |score|
      create_beer_with_rating(object, score)
    end
  end

  def create_beers_with_many_ratings_and_custom_styles(object, *scores, style)
    scores.each do  |score|
      create_beer_with_rating(object, score, style)
    end
  end
end