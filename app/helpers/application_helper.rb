module ApplicationHelper
  # The following are routing helpers
  def reroute_invalid_session
    unless logged_in?
      redirect_to root_path
      raise CustomError::Unauthenticated
    end
  end

  def reroute_valid_session
    redirect_to tickets_path if logged_in?
  end

  def reject_blank_auth_values
    if params[:email].empty? && params[:password].empty?
      redirect_to signup_path
      flash[:error] = "Email and password must not be empty"
    elsif params[:email].empty?
      redirect_to signup_path
      flash[:error] = "Email must not be empty"
    elsif params[:password].empty?
      redirect_to signup_path
      flash[:error] = "Password must not be empty"
    end
  end

  # The following is a helper to set bootstrap class for flash
  # based on the type of clash
  def bootstrap_class_for_flash(flash_type)
    case flash_type
    when "success" then "alert-success"
    when "warning" then "alert-warning"
    when "error" then "alert-danger"
    when "alert" then "alert-warning"
    when "notice" then "alert-info"
    else flash_type.to_s
    end
  end

  def format_time(time)
    if time.respond_to?(:strftime)
      time.strftime("%-I:%M %P - %A %B %d, %Y")
    else
      time
    end
  end

  def get_ticket(id)
    if current_user.customer?
      current_user.tickets.find(id)
    else
      Ticket.find(id)
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to tickets_path
    raise CustomError::NotFound, "Ticket not found"
  end

  def get_user(id)
    verify_admin

    User.find(id)
  rescue ActiveRecord::RecordNotFound
    redirect_to tickets_path
    raise CustomError::NotFound, "User not found"
  end

  def tickets_by_scope(scope)
    case scope.to_s.underscore.downcase
    when "pending" then Ticket.pending
    when "processing" then Ticket.processing
    when "closed" then Ticket.closed
    when "recently_closed" then Ticket.recently_closed
    else Ticket.all
    end
  end

  def verify_agent
    unless current_user.agent?
      raise CustomError::Unauthorized
    end
  end

  def verify_admin
    unless current_user.admin?
      redirect_to tickets_path
      raise CustomError::Unauthorized
    end
  end
end
