class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate params[:session][:password]
      log_in user
      redirect_to user
    else
      redirect_to login_path, danger: t("errors.email")
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end
end
