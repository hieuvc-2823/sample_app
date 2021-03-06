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
      if user&.authenticated?(cookies[:remember_token])
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
end
