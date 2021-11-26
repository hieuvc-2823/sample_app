class UsersController < ApplicationController
  before_action :check_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy(User.all, items: Settings.users.per_page)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = t "users.active_warning"
      redirect_to static_pages_home_path, info: t("users.active_warning")
    else
      log_in @user
      render :show
    end
  end

  def new
    @user = User.new
  end

  def edit; end

  def show
    return if @user

    flash[:danger] = t "errors.user"
    redirect_to static_pages_home_path, danger: t("users.invalid")
  end

  def update
    if @user.update(user_params)
      redirect_to @user, success: t("users.update")
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, success: t("users.delete")
  end

  def logged_in_user
    return if logged_in?

    store_location
    redirect_to login_path, danger: t("errors.login")
  end

  def correct_user
    return if current_user?(@user)

    redirect_to static_pages_home_path, danger: t("users.invalid")
  end

  def admin_user
    return if current_user.admin?

    redirect_to static_pages_home_path, danger: t("users.invalid")
  end

  def check_user
    @user = User.find_by(id: params[:id])
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :birthday,
      :password,
      :password_confirmation
    )
  end
end
