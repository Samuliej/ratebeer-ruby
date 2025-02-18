class RatingsController < ApplicationController
  # Index renderöi suorituksen lopuksi oikeassa
  # hakemistossa olevan index-nimisen näkymän
  # render :index
  def index
    @ratings = Rating.all
  end
end
