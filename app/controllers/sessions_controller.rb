class SessionsController < ApplicationController
  def new
    # Renderöidään kirjatumissivu
  end

  def create
    # Haetaan nimeä vastaava käyttäjä tietokannasta
    user = User.find_by username: params[:username]

    if user.disabled?
      redirect_to new_session_path, notice: "Your account has been disabled. Please contact an administrator."
    elsif user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
    else
      redirect_to new_session_path, notice: "Username and/or password mismatch"
    end
  end

  def destroy
    session[:user_id] = nil
    # Uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end
