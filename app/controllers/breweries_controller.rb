class BreweriesController < ApplicationController
  before_action :set_brewery, only: %i[show edit update destroy]
  before_action :set_active_breweries, only: %i[active]
  before_action :set_retired_breweries, only: %i[retired]
  before_action :ensure_that_signed_in, except: [:index, :show, :active, :retired]
  before_action :ensure_that_user_is_admin, only: %i[destroy]
  before_action :expire_breweries, only: %i[edit update destroy create]

  # GET /breweries or /breweries.json
  def index
    if params[:format] == "json"
      @breweries = Brewery.includes(:beers).all
    end

    @active_breweries_tag = "active_brewery_list_frame"
    @retired_breweries_tag = "retired_brewery_list_frame"
  end

  # GET /breweries/1 or /breweries/1.json
  def show
  end

  # GET /breweries/new
  def new
    @brewery = Brewery.new
  end

  def list
  end

  # GET /breweries/1/edit
  def edit
  end

  def active
    render partial: "active_breweries_table", locals: { active_breweries: @active_breweries, active_tag: "active_brewery_list_frame" }
  end

  def retired
    render partial: "retired_breweries_table", locals: { retired_breweries: @retired_breweries, retired_tag: "retired_brewery_list_frame" }
  end

  # POST /breweries or /breweries.json
  def create
    @brewery = Brewery.new(brewery_params)

    respond_to do |format|
      if @brewery.save
        format.turbo_stream { render_create_turbo_stream }
        format.html { redirect_to @brewery, notice: I18n.t('notices.brewery_created') }
        format.json { render :show, status: :created, location: @brewery }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /breweries/1 or /breweries/1.json
  def update
    respond_to do |format|
      if @brewery.update(brewery_params)
        format.html { redirect_to @brewery, notice: I18n.t('notices.brewery_updated') }
        format.json { render :show, status: :ok, location: @brewery }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /breweries/1 or /breweries/1.json
  def destroy
    @brewery.destroy!

    respond_to do |format|
      format.turbo_stream {
        status = @brewery.active? ? "active" : "retired"

        render turbo_stream: [
          turbo_stream.remove(@brewery),
          turbo_stream.replace("#{status}_brewery_count", partial: "brewery_count", locals: { status: status })
        ]
      }
      format.html { redirect_to breweries_path, status: :see_other, notice: I18n.t('notices.brewery_destroyed') }
      format.json { head :no_content }
    end
  end

  def toggle_activity
    brewery = Brewery.find(params[:id])
    brewery.update_attribute :active, !brewery.active?

    new_status = brewery.active? ? "active" : "retired"

    redirect_to brewery, notice: "Brewery activity status changed to #{new_status}"
  end

  private

  def render_create_turbo_stream
    status = brewery_status(@brewery)
    render turbo_stream: [
      turbo_stream.append("#{status}_brewery_rows", partial: "brewery_row", locals: { brewery: @brewery }),
      turbo_stream.replace("#{status}_brewery_count", partial: "brewery_count", locals: { status: status })
    ]
  end

  def brewery_status(brewery)
    brewery.active? ? "active" : "retired"
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_brewery
    @brewery = Brewery.find(params.expect(:id))
  end

  def set_active_breweries
    @active_breweries = Brewery.includes(:beers, :ratings).active
  end

  def set_retired_breweries
    @retired_breweries = Brewery.includes(:beers, :ratings).retired
  end

  # Only allow a list of trusted parameters through.
  def brewery_params
    params.require(:brewery).permit(:name, :year, :active)
  end
end
