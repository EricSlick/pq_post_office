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

ActiveRecord::Schema[7.0].define(version: 2022_12_05_170731) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "messages", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.string "status", limit: 15
    t.string "phone", limit: 30
    t.string "body"
    t.string "adapter"
    t.string "remote_id"
    t.datetime "sent_at"
    t.datetime "delivered_at"
    t.string "status_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "adapters_tried"
    t.index ["phone"], name: "index_messages_on_phone"
    t.index ["status"], name: "index_messages_on_status"
    t.index ["uuid"], name: "index_messages_on_uuid", unique: true
  end

  create_table "strategies", force: :cascade do |t|
    t.string "name", null: false
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "third_parties", force: :cascade do |t|
    t.string "api"
    t.string "name"
    t.string "health"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
