# app/models/concerns/status_enum.rb
module StatusEnum
  extend ActiveSupport::Concern

  included do
    enum :status, {
      pending: 'pending',
      processed: 'processed',
      cancelled: 'cancelled',
      delivered: 'delivered',
      returned: 'returned',
      delayed: 'delayed',
      returning: 'returning',
      shipped: 'shipped'
    }, _prefix: true, default: :pending, validate: true
  end
end