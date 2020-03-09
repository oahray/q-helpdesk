class Admin::AgentsController < ApplicationController
  before_action :verify_admin
  before_action :set_user

  def add_agent
    @user = @user.update(support_agent: true)

    redirect_to admin_dashboards_path
  end

  def remove_agent
    @user = @user.update(support_agent: false)

    redirect_to admin_dashboards_path
  end

  private

  def set_user
    @user = get_user(params[:id])
  end
end
