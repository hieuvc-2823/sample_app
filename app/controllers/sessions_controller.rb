class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate params[:session][:password]
      # create new session
      log_in user
      # create cookie in order to remember user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_to user
    else
      redirect_to users_login_path, danger: "Invalid email/password combination"
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to users_login_path
  end
end