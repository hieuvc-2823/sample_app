class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t "home.header"
      redirect_to @user
    else
      render :new
    end
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:danger] = t "errors.user"
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
