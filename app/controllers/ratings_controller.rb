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
    @rating = Rating.new rating_params
    @rating.user = current_user

    if @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      # Rails 7 ei renderöi erroreita, ellei palauta myös symbolia :unprocessable_entity
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @rating = Rating.find(params[:id])
    @rating.delete
    redirect_to ratings_path
  end

  private

  def rating_params
    params.expect(rating: [:score, :beer_id])
  end
end
