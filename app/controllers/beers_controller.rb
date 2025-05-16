class BeersController < ApplicationController
  before_action :set_beer, only: %i[show edit update destroy]
  before_action :set_brewery_and_styles, only: %i[new edit update create]
  before_action :ensure_that_signed_in, except: [:index, :show, :list]
  before_action :ensure_that_user_is_admin, only: %i[destroy]
  before_action :expire_beerlist, only: %i[edit update create destroy]
  before_action :expire_breweries, only: %i[create destroy]
  PAGE_SIZE = 15

  # GET /beers or /beers.json
  def index
    @order = params[:order] || 'name'
    @page = params[:page]&.to_i || 1
    @last_page = (Beer.count / PAGE_SIZE.to_f).ceil
    offset = (@page - 1) * PAGE_SIZE

    @beers_size = Beer.count
    @beers = case @order
             when "name" then Beer.includes(:style, :brewery, :ratings).order(:name)
             when "brewery" then Beer.joins(:brewery).order("breweries.name")
             when "style" then Beer.joins(:style).order("styles.name")
             when "rating" then Beer.left_joins(:ratings).select("beers.*, avg(ratings.score)").group("beers.id").order("avg(ratings.score) desc")
             else
               Beer.order(:name)
             end.limit(PAGE_SIZE).offset(offset)

    if turbo_frame_request?
      render partial: "beer_list",
             locals: { beers: @beers, page: @page, order: @order, last_page: @last_page }
    else
      render :index
    end
  end

  def list
  end

  # GET /beers/1 or /beers/1.json
  def show
    @rating = Rating.new
    @rating.beer = @beer
  end

  # GET /beers/new
  def new
    @beer = Beer.new
  end

  # GET /beers/1/edit
  def edit
    # Ei ollut ongelmaa että editointi ei toimi, sillä olin tehnyt
    # before actionin joka toimii editillekkin
  end

  # POST /beers or /beers.json
  def create
    @beer = Beer.new(beer_params)

    respond_to do |format|
      if @beer.save
        format.html { redirect_to beers_path, notice: "Beer was successfully created." }
        format.json { render :show, status: :created, location: @beer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beers/1 or /beers/1.json
  def update
    respond_to do |format|
      if @beer.update(beer_params)
        format.html { redirect_to @beer, notice: "Beer was successfully updated." }
        format.json { render :show, status: :ok, location: @beer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beers/1 or /beers/1.json
  def destroy
    @beer.destroy!

    respond_to do |format|
      format.html { redirect_to beers_path, status: :see_other, notice: "Beer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_beer
    @beer = Beer.includes(:brewery, :style, :ratings).find(params.expect(:id))
  end

  # Unohdin että tein tehtävän 10 myös
  # kun aloin korjailemaan testejä
  def set_brewery_and_styles
    @breweries = Brewery.all
    @styles = Style.all
  end

  # Only allow a list of trusted parameters through.
  def beer_params
    params.expect(beer: [:name, :style_id, :brewery_id])
  end
end
