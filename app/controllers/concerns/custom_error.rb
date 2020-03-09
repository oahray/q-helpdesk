module CustomError
  extend ActiveSupport::Concern

  # The following are custom error classes.
  # Add new clases here, and they can be globally rescued here
  class ActionForbidden < StandardError; end
  class NotFound < StandardError; end
  class Unauthenticated < StandardError; end
  class Unauthorized < StandardError; end

  included do
    rescue_from CustomError::ActionForbidden, with: :flash_message
    rescue_from CustomError::NotFound, with: :flash_message
    rescue_from CustomError::Unauthorized do
      flash[:error] = "Insufficient permissions to carry out that action"
    end
    rescue_from CustomError::Unauthenticated do
      flash[:error] = "Please login to continue"
    end
  end

  private

  def flash_message(message = e.message)
    flash[:error] = message
  end
end
