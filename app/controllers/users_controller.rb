class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = t "users.active_warning"
      redirect_to static_pages_home_path
    else
      log_in @user
      render :show
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 8)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = t "users.update"
      redirect_to @user
    else
      render :edit
    end
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "errors.login"
    redirect_to login_path
  end

  def correct_user
    @user = User.find(params[:id])
    return if current_user?(@user)

    redirect_to static_pages_home_path
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t "users.delete"
    redirect_to users_path
  end

  def admin_user
    return if current_user.admin?

    redirect_to static_pages_home_path
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
