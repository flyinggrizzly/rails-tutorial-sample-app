class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]

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

  private

  def edit
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end
end
