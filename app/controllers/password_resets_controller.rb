class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:passwor_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'An email has been sent with password reset instructions.'
      redirect_to root_url
    else
      flash.now[:danger] = "That email address doesn't match any users."
      render 'new'
    end
  end
  
  def edit
  end
end
