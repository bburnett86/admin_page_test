class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.string :description, null: false
      t.string :status, null: false, default: 'new'
      t.references :user
      t.references :notifiable, polymorphic: true, optional: true

      t.timestamps
    end
  end
end
