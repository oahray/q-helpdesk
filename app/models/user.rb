class User < ApplicationRecord
  has_secure_password

  has_many :tickets, class_name: "Ticket", foreign_key: :customer
  has_many :handled_tickets, class_name: "Ticket", foreign_key: :closed_by
  has_many :comments

  validates_presence_of :password_digest
  validates :email, presence: true, uniqueness: true, case_sensitive: false

  scope :agents, -> { where(support_agent: true) }
  scope :customers, -> { where(admin: false, support_agent: false) }
  scope :admins, -> { where(admin: true) }

  def agent?
    admin? || support_agent?
  end

  def customer?
    !agent?
  end

  def can_export?
    agent?
  end

  concerning :Tickets do
    def can_comment?(ticket)
      ticket.commentable?(self)
    end

    def close(ticket)
      if agent?
        ticket.tap do |r|
          r.processing = false
          r.closed = true
          r.closed_at = DateTime.now
          r.closed_by = self
          r.save
        end
      end
    end

    def process(ticket)
      if agent?
        ticket.tap do |r|
          r.processing = true
          r.process_start_at = DateTime.now
          r.closed = false
          r.closed_at = nil
          r.save
        end
      end
    end

    def reset(ticket)
      if agent?
        ticket.tap do |r|
          r.processing = false
          r.process_start_at = nil
          r.closed = false
          r.closed_at = nil
          r.closed_by = nil
          r.save
        end
      end
    end
  end
end
