class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: [:destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  # Non-RESTtful resource. Provides a non-JS fall-back for the destroy action.
  # For source and details see RailsCast 77 revised:
  # http://railscasts.com/episodes/77-destroy-without-javascript-revised?autoplay=true
  def delete
    @micropost = Micropost.find(params[:id])
  end

  def destroy
    Micropost.find(params[:id]).destroy
    flash[:success] = 'Micropost deleted'

    # If the referring URL has just been deleted, don't go there
    if request.referer
      if request.referer.include? params[:id]
        redirect_to root_url
      end
    else # otherwise go back there if we can
        redirect_to request.referer || root_url
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
