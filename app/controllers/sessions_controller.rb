class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate params[:session][:password]
      user_active?(user)
    else
      redirect_to users_login_path, danger: t("errors.pwd")
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to users_login_path
  end
end
