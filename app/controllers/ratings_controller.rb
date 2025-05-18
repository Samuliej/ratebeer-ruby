class RatingsController < ApplicationController
  include RatingAverage
  before_action :expire_breweries, only: %i[create destroy]
  before_action :expire_beerlist, only: %i[create destroy]
  PAGE_SIZE = 10

  # Index renderöi suorituksen lopuksi oikeassa
  # hakemistossa olevan index-nimisen näkymän
  # render :index

  # Workerissa laitetaan asynkronisesti minuutin välein
  # cacheen kaikki parhaimpien arvot
  # Toimii deployattuna jossa worker erillisessä VM:ssä.
  def index
    @top_beers = Beer.top 3
    @top_breweries = Brewery.top 3
    @top_styles = Style.top 3

    @order = params[:order] != "false"
    @page = params[:page]&.to_i || 1
    @last_page = (Rating.count / PAGE_SIZE.to_f).ceil
    offset = (@page - 1) * PAGE_SIZE

    @all_ratings = if @order
                     Rating.includes(:user, :beer).order(created_at: :desc)
                   else
                     Rating.includes(:user, :beer).order(created_at: :asc)
                   end.limit(PAGE_SIZE).offset(offset)
  end

  # Luodaan Rating olio, ja välitetään se instanssimuuttujan
  # avulla oletusarvoisesti renderöitävälle näkymätemplatelle
  def new
    @rating = Rating.new
    # Luodaan oluista instanssimuuttuja, jotta
    # ratingin "tiedossa" on kaikki oluet
    @beers = Beer.all
  end

  def show
    return unless turbo_frame_request?

    @rating = Rating.find(params[:id])
    render partial: 'rating_details', locals: { rating: @rating }
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
    destroy_ids = request.body.string.split(',')

    destroy_ids.each do |id|
      rating = Rating.find(id.to_i)
      rating.destroy if rating && current_user == rating.user
    rescue StandardError => e
      puts "Rating record has an error: #{e.message}"
    end

    @user = current_user
    respond_to do |format|
      format.html { render partial: 'users/ratings', status: :ok, user: @user }
    end
  end

  # def destroy
  #   @rating = Rating.find(params[:id])
  #   @rating.delete if current_user == @rating.user
  #   redirect_to user_path(current_user), notice: "Rating deleted"
  # end

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
