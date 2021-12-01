class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :logged_in_user, only: [:all, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = I18n.t('users.active_warning')
      redirect_to static_pages_home_path
    else
      log_in @user
      render :show
    end
  end

  def all
    @users = User.paginate(page: params[:page], per_page: 8)
  end

  def show
    @user = User.new
  end

  def index
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = I18n.t "users.update"
      redirect_to @user
    else
      render :edit
    end
  end

  def logged_in_user
    unless logged_in?
    store_location
    flash[:danger] = I18n.t "errors.login"
    redirect_to users_login_path
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to static_pages_home_path unless current_user?(@user)
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_path
  end

  def admin_user
    redirect_to static_pages_home_path unless current_user.admin?
  end


  private
  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end
end
