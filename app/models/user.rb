# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders
  has_many :assigned_tickets, class_name: "Ticket", foreign_key: "assigned_to"
  has_many :created_tickets, class_name: "Ticket", foreign_key: "creator"
  has_many :notifications

  validates :first_name, :last_name, presence: true, length: { minimum: 3 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
  validates :role, presence: true
  validate :password_complexity

  enum :role, {
    standard: "standard",
    customer_service: "customer service",
    manager: "manager",
    admin: "admin",
  }, default: :standard, _prefix: true, validate: true

private

  def password_complexity
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/

    errors.add :password, "Complexity requirement not met. Length should be 8-30 characters and include: 1 uppercase, 1 lowercase, 1 digit and 1 special character"
  end
end
