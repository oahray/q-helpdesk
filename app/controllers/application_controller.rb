class ApplicationController < ActionController::Base
  include ApplicationHelper
  include CustomError
  protect_from_forgery
  helper_method :current_user, :logged_in?

  private

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    end
  rescue ActiveRecord::RecordNotFound
    @current_user = nil
  end

  def logged_in?
    current_user.present?
  end
end
