class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate params[:session][:password]
      if user.activated?
        log_in user
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        redirect_back_or user
      else
        message = I18n.t("users.active_warning")
        flash[:warning] = message
        redirect_to static_pages_home_path
      end
    else
      redirect_to users_login_path, danger: I18n.t("errors.pwd")
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to users_login_path
  end
end
