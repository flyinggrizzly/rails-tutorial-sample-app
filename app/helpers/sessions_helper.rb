module SessionsHelper
  # Logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end

  # Sets cookies to remmeber the user for 10 days
  def remember(user)
    # Require semi-frequent logins for security
    expiry_date = 10.days.from_now.utc
    user.remember
    cookies.signed[:user_id] = { value:   user.id,
                                 expires: expiry_date }
    cookies[:remember_token] = { value:   user.remember_token,
                                 expires: expiry_date }
  end

  # Forgets a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs current user out
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Returns the current logged in user, if any.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Returns true if the user is logged in, false otherwise
  def logged_in?
    !current_user.nil?
  end

  # Returns true if given user is the current user
  def current_user?(user)
    user == current_user
  end

  # Record requested URL for logged out users to friendly redirect after login
  def store_destination
    session[:intended_destination_url] = request.original_url if request.get?
  end

  # Redirect newly logged in users to their intended URL or to default
  def redirect_back_or(default)
    redirect_to(session[:intended_destination_url] || default)
    session.delete(:intended_destination_url)
  end
end
