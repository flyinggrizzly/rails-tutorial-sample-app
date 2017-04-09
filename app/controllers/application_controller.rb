class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def hello
    render "Sup, y'all?"
  end
end
