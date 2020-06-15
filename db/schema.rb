# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_16_081510) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "containers", force: :cascade do |t|
    t.string "container_uid"
    t.string "container_prefix"
    t.string "container_number"
    t.date "schedule_date"
    t.date "unstuff_date"
    t.datetime "last_day"
    t.date "f5_unstuff_date"
    t.datetime "f5_last_day"
    t.string "location"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "eta"
    t.datetime "cod"
    t.string "client_id"
    t.index ["container_number"], name: "index_containers_on_container_number"
    t.index ["id"], name: "index_containers_on_id"
  end

  create_table "devices", force: :cascade do |t|
    t.string "device_token"
    t.string "device_platform"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["device_token"], name: "index_devices_on_device_token", unique: true
  end

  create_table "hbls", force: :cascade do |t|
    t.string "inventory_id"
    t.string "hbl_uid"
    t.string "sequence_no"
    t.string "sequence_prefix"
    t.string "pod"
    t.string "mquantity"
    t.string "mtype"
    t.string "mvolume"
    t.string "mweight"
    t.bigint "container_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "markings"
    t.string "length"
    t.string "breadth"
    t.string "height"
    t.string "remarks"
    t.string "total_amount"
    t.string "status"
    t.index ["container_id"], name: "index_hbls_on_container_id"
  end

  create_table "notification_items", force: :cascade do |t|
    t.string "container_number"
    t.string "message"
    t.bigint "device_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_new", default: false
    t.string "title"
    t.string "colour"
    t.string "hbl_uid"
    t.index ["device_id"], name: "index_notification_items_on_device_id"
  end

  create_table "notification_jobs", force: :cascade do |t|
    t.string "title"
    t.string "message"
    t.boolean "is_sent", default: false
    t.datetime "send_at"
    t.bigint "container_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status_output"
    t.bigint "hbl_id"
    t.index ["container_id", "created_at"], name: "index_notification_jobs_on_container_id_and_created_at"
    t.index ["container_id"], name: "index_notification_jobs_on_container_id"
    t.index ["hbl_id"], name: "index_notification_jobs_on_hbl_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "contact_number"
    t.string "device_token"
    t.string "device_platform"
    t.boolean "is_retrieved", default: false
    t.boolean "is_activated", default: false
    t.datetime "activated_at"
    t.bigint "container_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "hbl_id"
    t.index ["container_id"], name: "index_notifications_on_container_id"
    t.index ["device_token"], name: "index_notifications_on_device_token"
    t.index ["hbl_id"], name: "index_notifications_on_hbl_id"
  end

  add_foreign_key "hbls", "containers"
  add_foreign_key "notification_items", "devices"
  add_foreign_key "notification_jobs", "containers"
  add_foreign_key "notification_jobs", "hbls"
  add_foreign_key "notifications", "containers"
  add_foreign_key "notifications", "hbls"
end
