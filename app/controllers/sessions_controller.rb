class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log in the user and redirect to the user's show page
    else
      flash[:danger] = 'Invalid email/password combination' # not quite right
      render 'new'
    end
  end

  def destroy
  end
end
