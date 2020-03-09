class ExportService
  EXPORTABLE_CLASSES = %w[Ticket]

  def initialize(content:, user:)
    @content = content
    @user = user
  end

  def to_csv
    raise CustomError::Unauthorized unless @user.agent?

    klass.to_csv(@content)
  end

  private

  def klass
    @content.first.class
  end
end
