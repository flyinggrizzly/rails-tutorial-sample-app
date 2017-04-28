class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update,
                                        :delete, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user, only: [:delete, :destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'Welcome to the Sample App!'
      redirect_to @user # equiv: redirect_to user_url(@user)
    else
      render 'new'
    end
  end

  def edit
    # No need to look up user; it's handled by before_action :correct_user
  end

  def update
    # Don't need to look up the user to edit; it's handled by before_action :correct_user
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  # Non-RESTtful resource. Provides a non-JS fall-back for the destroy action.
  # For source and details see RailsCast 77 revised:
  # http://railscasts.com/episodes/77-destroy-without-javascript-revised?autoplay=true
  def delete
    @user = User.find(params[:id])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to users_url
  end

  private

  # Strengthen parameters being passed to prevent shenanigans
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Redirects anonymous users to sign in before accessing privileged pages
  def logged_in_user
    unless logged_in?
      store_destination
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end

  # Redirects users trying to access someone else's edit and update actions
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
