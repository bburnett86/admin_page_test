# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_10_07_194130) do
  create_table "notifications", force: :cascade do |t|
    t.string "description", null: false
    t.string "status", default: "new", null: false
    t.integer "user_id"
    t.string "notifiable_type"
    t.integer "notifiable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index %w[notifiable_type notifiable_id], name: "index_notifications_on_notifiable"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.string "order_id", null: false
    t.string "product_id", null: false
    t.string "status", default: "pending", null: false
    t.decimal "current_price", precision: 10, scale: 2
    t.decimal "sale_price", precision: 10, scale: 2
    t.decimal "percentage_off", precision: 5, scale: 2
    t.decimal "cost", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "expected_delivery_date"
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "status", default: "processed", null: false
    t.string "user_id", null: false
    t.date "expected_delivery_date", default: -> { "CURRENT_DATE" }
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.float "cost", null: false
    t.integer "inventory_count", default: 0, null: false
    t.decimal "current_price", precision: 10, scale: 2
    t.decimal "sale_price", precision: 10, scale: 2
    t.decimal "percentage_off", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.index ["name"], name: "index_products_on_name"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "description", null: false
    t.string "status", default: "new", null: false
    t.string "ticket_type", default: "other", null: false
    t.boolean "active", default: true
    t.date "process_by", default: -> { "CURRENT_DATE" }
    t.string "ticketable_type"
    t.integer "ticketable_id"
    t.integer "creator_id"
    t.integer "assigned_to_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "assigned_to"
    t.integer "creator"
    t.index ["assigned_to"], name: "index_tickets_on_assigned_to"
    t.index ["assigned_to_id"], name: "index_tickets_on_assigned_to_id"
    t.index ["creator"], name: "index_tickets_on_creator"
    t.index ["creator_id"], name: "index_tickets_on_creator_id"
    t.index %w[ticketable_type ticketable_id], name: "index_tickets_on_ticketable"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "role", default: "standard", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index %w[first_name last_name], name: "index_users_on_first_name_and_last_name"
    t.index ["first_name"], name: "index_users_on_first_name"
    t.index ["last_name"], name: "index_users_on_last_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "tickets", "users", column: "assigned_to"
  add_foreign_key "tickets", "users", column: "assigned_to_id"
  add_foreign_key "tickets", "users", column: "creator"
  add_foreign_key "tickets", "users", column: "creator_id"
end
