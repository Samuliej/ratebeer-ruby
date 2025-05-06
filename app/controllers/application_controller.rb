class ApplicationController < ActionController::Base
  # Määritellään, että metodi current_user tulee käyttöön myös näkymissä
  helper_method :current_user, :member_of_this_club?, :top, :application_sent?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  around_action :switch_locale

  def switch_locale(&)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &)
  end

  def current_user
    return nil if session[:user_id].nil?

    @current_user ||= User.find(session[:user_id])
  end

  def ensure_that_signed_in
    redirect_to new_session_path, notice: "Please sign in" unless current_user
  end

  def ensure_that_user_is_admin
    redirect_to root_path, notice: "You don't have the permission to do that" unless current_user.admin?
  end

  def member_of_this_club?(beer_club)
    beer_club.confirmed_users.include? current_user
  end

  def application_sent?(beer_club)
    beer_club.unconfirmed_users.include? current_user
  end

  def top(record, number)
    record.all.sort_by(&:average_rating).reverse.take(number)
  end

  private

  def expire_breweries
    expire_fragment("brewerylist")
  end

  def expire_beerlist
    %w[beerlist-name beerlist-brewery beerlist-style].each{ |f| expire_fragment(f) }
  end
end
