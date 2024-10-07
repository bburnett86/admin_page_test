class AddAssignedToAndCreatorToTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :tickets, :assigned_to, :integer
    add_column :tickets, :creator, :integer
    add_foreign_key :tickets, :users, column: :assigned_to
    add_foreign_key :tickets, :users, column: :creator
    add_index :tickets, :assigned_to
    add_index :tickets, :creator
  end
end
