class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def flying_grizzly
    render html: "flap, flap, grr"
  end
end
