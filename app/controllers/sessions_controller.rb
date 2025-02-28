class SessionsController < ApplicationController
  def new
    # Renderöidään kirjatumissivu
  end

  def create
    # Haetaan nimeä vastaava käyttäjä tietokannasta
    user = User.find_by username: params[:username]

    if user.nil?
      redirect_to signin_path, notice: "User #{params[:username]} does not exist!"
    else
      # Tallennetaan käyttäjän id sessioon jos käyttäjä löytyi
      session[:user_id] = user.id if user

      # Uudelleenohjataan käyttäjä omalle sivulle
      redirect_to user, notice: "Welcome back!"
    end
  end

  def destroy
    session[:user_id] = nil
    # Uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end
