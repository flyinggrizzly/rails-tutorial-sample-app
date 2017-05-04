class ApplicationController < ActionController::Base
  include SessionsHelper
  protect_from_forgery with: :exception

  def hello
    render html: "Sup, y'all?"
  end

  private

  # Redirects anonymous users to sign in before accessing privileged pages
  def logged_in_user
    unless logged_in?
      store_destination
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end
end
