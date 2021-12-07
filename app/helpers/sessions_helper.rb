module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end
  # get the current user

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by id: user_id
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by id: user_id
      if user&.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  # check user login or not

  def logged_in?
    current_user.present?
  end
  # delete session

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # remember user by create cookie via user_id and remember_token

  def remember user
    # create new token and stored token is already hased in the database
    user.remember
    # create cookie
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget user
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def current_user? user
    user && user == current_user
  end

  def redirect_back_or default
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def user_active? user
    log_in user
    if user.activated?
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_back_or user
    else
      message = t "users.active_warning"
      flash[:warning] = message
      redirect_to static_pages_home_path
    end
  end
end
