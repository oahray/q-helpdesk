class Admin::DashboardsController < ApplicationController
  before_action :verify_admin
  
  def index
    @agents = User.agents
    @customers = User.customers
  end
end
