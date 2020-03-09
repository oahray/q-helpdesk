class TicketStatusController < ApplicationController
  before_action :verify_agent
  before_action :set_ticket

  def start_process
    if TicketService.new(ticket: @ticket, user: current_user).process
      flash[:success] = "Ticket is now being processed."
      redirect_to @ticket
    else
      flash[:error] = @ticket.errors.full_messages.to_sentence
    end
  end

  def close
    if TicketService.new(ticket: @ticket, user: current_user).close
      flash[:success] = "Ticket is now closed."
      redirect_to @ticket
    else
      flash[:error] = @ticket.errors.full_messages.to_sentence
    end
  end

  def reset
    if TicketService.new(ticket: @ticket, user: current_user).reset
      flash[:success] = "Ticket has been reset."
      redirect_to @ticket
    else
      flash[:error] = @ticket.errors.full_messages.to_sentence
    end
  end

  private

  def set_ticket
    @ticket = get_ticket(params[:id])
  end
end