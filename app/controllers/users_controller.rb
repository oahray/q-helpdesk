class UsersController < ApplicationController
  before_action :reroute_valid_session, only: %i[new]
  before_action :reject_blank_auth_values, only: %i[create]

  def new; end

  def create
    @user = User.new(permitted_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Account creation successful"
      redirect_to tickets_path
    else
      redirect_to signup_path
      flash[:error] = @user.errors.full_messages.to_sentence
    end
  end

  private

  def permitted_params
    params.permit(:email, :password)
  end

  def set_user
    @user = current_user
  end
end

