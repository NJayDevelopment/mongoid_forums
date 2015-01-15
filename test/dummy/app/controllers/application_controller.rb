class ApplicationController < ActionController::Base

  def mongoid_forums_user
    current_user
  end

  helper_method :mongoid_forums_user

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
