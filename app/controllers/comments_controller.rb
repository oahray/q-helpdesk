class CommentsController < ApplicationController
  before_action :set_ticket, only: %i[index create]
  before_action :verify_ownership, only: %i[update delete]

  def index
  end

  def new; end

  def create
    comment = current_user.comments.new(permitted_params)

    if comment.save
      flash[:success] = "Comment posted"
      redirect_to ticket_path(@ticket)
    else
      flash[:warning] = comment.errors.full_messages.to_sentence
    end
  end

  private

  def permitted_params
    params.permit(:body).merge(ticket: @ticket)
  end

  def set_ticket
    @ticket = get_ticket(params[:id])
  end

  def verify_ownership
  end
end
