class BeersController < ApplicationController
  before_action :set_beer, only: %i[show edit update destroy]
  before_action :set_brewery_and_styles, only: %i[new edit update create]
  before_action :ensure_that_signed_in, except: [:index, :show]

  # GET /beers or /beers.json
  def index
    @beers = Beer.all
  end

  # GET /beers/1 or /beers/1.json
  def show
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
    @beer = Beer.find(params.expect(:id))
  end

  # Unohdin että tein tehtävän 10 myös
  # kun aloin korjailemaan testejä
  def set_brewery_and_styles
    @breweries = Brewery.all
    @styles = ["Weizen", "Lager", "Pale ale", "IPA", "Porter", "Lowalcohol", "NEIPA"]
  end

  # Only allow a list of trusted parameters through.
  def beer_params
    params.expect(beer: [:name, :style, :brewery_id])
  end
end
