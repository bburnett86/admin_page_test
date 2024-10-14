# frozen_string_literal: true

class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.string :description, null: false
      t.string :status, null: false, default: "new"
      t.string :ticket_type, null: false, default: "other"
      t.boolean :active, default: true
      t.date :process_by, default: -> { "CURRENT_DATE" }
      t.references :ticketable, polymorphic: true, optional: true
      t.references :creator, foreign_key: { to_table: :users }
      t.references :assigned_to, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
