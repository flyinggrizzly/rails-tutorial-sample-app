class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]

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
    # Don't need to look up the user to edit; it's handled by before_action :correct_user
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
end
