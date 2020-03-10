class TicketService
  def initialize(ticket:, user:)
    @ticket = ticket
    @user = user
  end

  def process
    ensure_agent!

    @user.process(@ticket)
  end

  def close
    ensure_agent!

    @user.close(@ticket)
  end

  def reset
    ensure_agent!

    @user.reset(@ticket)
  end

  def ensure_agent!
    raise CustomError::Unauthorized unless @user.agent?
  end
end
