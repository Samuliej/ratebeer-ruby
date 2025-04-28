class RatingsController < ApplicationController
  include ControllerHelper
  include RatingAverage

  # Index renderöi suorituksen lopuksi oikeassa
  # hakemistossa olevan index-nimisen näkymän
  # render :index
  def index
    @ratings = Rating.all.includes(:beer) # Ladataan oluet samalla kyselyllä
    @top_beers = top(Beer, 3)
    @top_breweries = top(Brewery, 3)
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
    @rating = Rating.new rating_params
    @rating.user = current_user

    respond_to do |format|
      if @rating.save
        format.html { redirect_to user_path(current_user), notice: "Rating created" }
        format.json { render }
      else
        @beers = Beer.all
        # Rails 7 ei renderöi erroreita, ellei palauta myös symbolia :unprocessable_entity
        render :new, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @rating = Rating.find(params[:id])
    @rating.delete if current_user == @rating.user
    redirect_to user_path(current_user), notice: "Rating deleted"
  end

  def best_beers
    best_rated(:beer)
  end

  def best_breweries
    best_rated(:brewery)
  end

  private

  def rating_params
    params.expect(rating: [:score, :beer_id])
  end
end
