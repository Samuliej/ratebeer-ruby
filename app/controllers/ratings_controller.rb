class RatingsController < ApplicationController
  include RatingAverage
  before_action :expire_breweries, only: %i[create destroy]
  before_action :expire_beerlist, only: %i[create destroy]

  # Index renderöi suorituksen lopuksi oikeassa
  # hakemistossa olevan index-nimisen näkymän
  # render :index

  # Workerissa laitetaan asynkronisesti minuutin välein
  # cacheen kaikki parhaimpien arvot
  # Toimii deployattuna jossa worker erillisessä VM:ssä.
  def index
    @top_beers = Rails.cache.read("beer_top_3")
    @top_breweries = Rails.cache.read("brewery_top_3")
    @top_styles = Rails.cache.read("style_top_3")
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
        # render :new, status: :unprocessable_entity
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
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
