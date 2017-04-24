class ApplicationController < ActionController::Base
  include SessionsHelper
  protect_from_forgery with: :exception

  def hello
    render html: "Sup, y'all?"
  end
end
