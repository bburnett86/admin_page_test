# frozen_string_literal: true

class Ticket < ApplicationRecord
  include TicketAnalytics

  enum status: {
    new_ticket: "new_ticket",
    manager_feedback: "manager_feedback",
    processing: "processing",
    awaiting_feedback: "awaiting_feedback",
    approved: "approved",
    no_action_required: "no_action_required",
    closed: "closed",
  }, _prefix: true

  enum ticket_type: {
    missing_part: "missing_part",
    not_performing_as_expected: "not_performing_as_expected",
    unexpected_outcome: "unexpected_outcome",
    needs_technical_solution: "needs_technical_solution",
    doesnt_match_description: "doesnt_match_description",
    other: "other",
  }, _prefix: :ticket_type

  belongs_to :ticketable, polymorphic: true
  belongs_to :creator, class_name: "User"
  belongs_to :assigned_to, class_name: "User", optional: true
  has_many :notifications, foreign_key: "notifiable_id", as: "notifiable"

  after_create :update_assigned_to_notification, if: -> { assigned_to.present? }
  after_update :update_assigned_to_notification, if: -> { assigned_to.present? && assigned_to_id_changed? }
  after_update :handle_status_change, if: :status_changed?

  validates :description, presence: true, length: { minimum: 5, maximum: 255 }
  validates :status, presence: true
  validates :ticket_type, presence: true
  validates :process_by, presence: true

  def item_related_tickets
    Ticket.where(ticketable: ticketable)
  end

  def handle_status_change
    notification_details =
      case status
      when "closed"
        { user: creator, description: "Ticket number ##{id} has been resolved", status: "success" }
        nil
      when "new_ticket"
        {  description: "Ticket has been created and will be attended to as soon as possible.", status: "success" }
      else
        { description: "Ticket number ##{id} has been updated to #{format_sym(status)}. Please review and provide feedback. It's current expected date of processing is #{process_by.strftime('%Y-%m-%d')}", status: "success", user: assigned_to } unless %w[new_ticket approved manager_feedback].include?(status)
      end

    send_update_notification(notification_details) if notification_details
  end

private

  def format_sym(sym)
    sym.to_s.split("_").map(&:capitalize).join(" ")
  end

  def update_assigned_to_notification
    formatted_process_by = process_by.strftime("%Y-%m-%d")

    CreateNotificationJob.perform_later(user: assigned_to, notifiable: self, description: "Ticket number ##{id} has been assigned to you. It is expected to be processed by #{formatted_process_by}", status: "success")
  end

  def send_update_notification(details)
    CreateNotificationJob.perform_later(user: details[:user] || user, notifiable: self, description: details[:description], status: details[:status])
  end
end
