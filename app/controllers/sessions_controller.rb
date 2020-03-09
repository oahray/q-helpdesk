class SessionsController < ApplicationController
  before_action :reroute_valid_session, only: :new
  before_action :reject_blank_auth_values, only: %i[create]

  def new; end

  def create
    user = User.find_by_email(params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome back"
      redirect_to tickets_path
    else
      flash[:warning] = "Email or password is incorrect"
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
    flash[:success] = "You have logged out"
  end
end
