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

ActiveRecord::Schema[7.0].define(version: 2023_09_11_150618) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chosen_offers", force: :cascade do |t|
    t.bigint "offer_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["offer_id"], name: "index_chosen_offers_on_offer_id"
    t.index ["user_id"], name: "index_chosen_offers_on_user_id"
  end

  create_table "gender_offer_criteria", force: :cascade do |t|
    t.bigint "offer_criterion_id", null: false
    t.bigint "gender_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gender_id"], name: "index_gender_offer_criteria_on_gender_id"
    t.index ["offer_criterion_id"], name: "index_gender_offer_criteria_on_offer_criterion_id"
  end

  create_table "genders", force: :cascade do |t|
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "offer_criteria", force: :cascade do |t|
    t.bigint "offer_id", null: false
    t.integer "min_age"
    t.integer "max_age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["offer_id"], name: "index_offer_criteria_on_offer_id"
  end

  create_table "offers", force: :cascade do |t|
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "username", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.date "birthdate", null: false
    t.bigint "gender_id", null: false
    t.string "custom_gender"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["gender_id"], name: "index_users_on_gender_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "chosen_offers", "offers"
  add_foreign_key "chosen_offers", "users"
  add_foreign_key "gender_offer_criteria", "genders"
  add_foreign_key "gender_offer_criteria", "offer_criteria"
  add_foreign_key "offer_criteria", "offers"
end
