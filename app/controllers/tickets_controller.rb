class TicketsController < ApplicationController
  before_action :reroute_invalid_session
  before_action :set_scope, only: %i[index export]
  before_action :set_tickets, only: %i[index export]
  before_action :set_ticket, only: %i[show]
  before_action :verify_ownership, only: %i[update]
  before_action :verify_agent, only: %i[export]

  def index; end

  def new; end

  def create
    @ticket = current_user.tickets.new(permitted_params)

    if @ticket.save
      flash[:success] = "New ticket successfully created."
      redirect_to @ticket
    else
      redirect_to new_ticket_path
      flash[:error] = @ticket.errors.full_messages.to_sentence
    end
  end

  def show; end

  def export
    respond_to do |format|
      format.html
      format.csv do
        export = ExportService.new(content: @tickets, user: current_user).to_csv
        send_data export, filename: "#{@scope.dasherize}-tickets-report-#{Date.today}.csv"
      end

      format.pdf do
        export = pdf_file
        send_data export, filename: "#{@scope.dasherize}-tickets-report-#{Date.today}.pdf"
      end
    end
  end

  private

  def pdf_file
    render_to_string(
      pdf: "#{@scope.dasherize}-tickets-report-#{Date.today}",
      template: "tickets/export.html.erb",
      orientation: "landscape",
      encoding: "UTF-8"
    )
  end
  
  def permitted_params
    params.permit(:title, :description)
  end

  def set_scope
    @scope = params[:scope] || "all"
  end

  def set_ticket
    @ticket = get_ticket(params[:id])
  end

  def set_tickets
    @tickets = current_user.customer? ? current_user.tickets : tickets_by_scope(@scope)
  end
end
