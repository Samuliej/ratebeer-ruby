class StylesController < ApplicationController
  before_action :set_style, only: %i[show edit update destroy]
  before_action :ensure_that_signed_in, except: [:index, :show, :about]
  before_action :ensure_that_user_is_admin, only: %i[destroy]

  def index
    @styles = Style.all
  end

  def about
    render partial: 'about'
  end

  def show
    return unless turbo_frame_request?

    render partial: 'details', locals: { style: @style }
  end

  def new
    @style = Style.new
  end

  def edit
  end

  def create
    @style = Style.new(style_params)

    respond_to do |format|
      if @style.save
        format.html { redirect_to styles_path, notice: "Style was successfully created." }
        format.json { render :show, status: :created, location: @style }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @style.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @style.update(style_params)
        format.html { redirect_to @style, notice: "Style was successfully updated." }
        format.json { render :show, status: :ok, location: @style }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @style.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @style.destroy!

    respond_to do |format|
      format.html { redirect_to styles_path, status: :see_other, notice: "Style was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_style
    @style = Style.find(params.expect(:id))
  end

  def style_params
    params.expect(style: [:name, :description, :style_id])
  end
end
