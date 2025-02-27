class ApplicationController < ActionController::Base
  # Määritellään, että metodi current_user tulee käyttöön myös näkymissä
  helper_method :current_user
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  around_action :switch_locale

  def switch_locale(&)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &)
  end

  def current_user
    return nil if session[:user_id].nil?

    User.find(session[:user_id])
  end
end
