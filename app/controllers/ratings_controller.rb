class RatingsController < ApplicationController
  # Index renderöi suorituksen lopuksi oikeassa
  # hakemistossa olevan index-nimisen näkymän
  # render :index
  def index
    @ratings = Rating.all
  end

  # Luodaan Rating olio, ja välitetään se instanssimuuttujan
  # avulla oletusarvoisesti renderöitävälle näkymätemplatelle
  def new
    @rating = Rating.new
    # Luodaan oluista instanssimuuttuja, jotta
    # ratingin "tiedossa" on kaikki oluet
    @beers = Beer.all
  end

  def create
    Rating.create params.require(:rating).permit(:score, :beer_id)
    redirect_to ratings_path
  end
end
