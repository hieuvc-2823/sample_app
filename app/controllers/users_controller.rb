class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Vo Chi Hieu Sample App!"
      redirect_to @user
    else
      render :show
    end
  end

  def show
    @user = User.new
  end

  def index
    @user = User.find(params[:id])
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
