class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_attribute(:activated, true)
      user.update_attribute(:activated_at, Time.zone.now)
      log_in user
      flash[:success] = I18n.t("success.active")
      redirect_to user
    else
      flash[:danger] = I18n.t("errors.active")
      redirect_to static_pages_home_path
    end
  end
end
