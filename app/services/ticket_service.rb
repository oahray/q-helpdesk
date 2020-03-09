class TicketService
  def initialize(ticket:, user:)
    @ticket = ticket
    @user = user
  end

  def process
    raise CustomError::Unauthorized unless @user.agent?

    @user.process(@ticket)
  end

  def close
    raise CustomError::Unauthorized unless @user.agent?

    @user.close(@ticket)
  end

  def reset
    raise CustomError::Unauthorized unless @user.agent?
    
    @user.reset(@ticket)
  end
end
