class Ticket < ApplicationRecord
  include CsvExportable

  EXPORTABLE_ATTRIBUTES = %w{# title description comments_count customer created_at status}.freeze
  
  belongs_to :customer, class_name: "User"
  belongs_to :closed_by, class_name: "User", optional: true
  has_many :comments

  validates :title, presence: true
  validates :description, presence: true

  scope :closed, -> { where(closed: true) }
  scope :processing, -> { where(processing: true) }
  scope :pending, -> { where(closed: false, processing: false) }
  scope :recently_closed, -> { where("closed_at between ? and ?", 2.months.ago, DateTime.current) }

  class << self
    def exportable_attributes
      EXPORTABLE_ATTRIBUTES
    end
  end

  def csv_data
    [id, title, description.to_s, comments_count, customer.email, created_at.utc.getlocal.strftime("%-I:%M %P - %A %B %m, %Y"), status]
  end

  def commentable?(user)
    has_comments? || user.agent?
  end

  def has_comments?
    comments.size > 0
  end

  def comments_count
    comments.size
  end

  def open?
    !processing? && !closed?
  end

  def status
    if closed?
      "closed"
    elsif processing?
      "processing"
    else
      "pending"
    end
  end
end
