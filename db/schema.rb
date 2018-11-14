# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20181114171826) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_histories", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id", "type"], name: "index_activity_histories_on_id_and_type"
    t.index ["user_id"], name: "index_activity_histories_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "course_enrollments", force: :cascade do |t|
    t.string "name"
    t.string "state"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_course_enrollments_on_user_id"
  end

  create_table "federal_assistances", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "federal_assistances_users", id: false, force: :cascade do |t|
    t.bigint "federal_assistance_id"
    t.bigint "user_id"
    t.index ["federal_assistance_id"], name: "index_federal_assistances_users_on_federal_assistance_id"
    t.index ["user_id"], name: "index_federal_assistances_users_on_user_id"
  end

  create_table "glossary_terms", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "source"
    t.string "remote_image_url"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.string "domain"
    t.string "logo"
    t.string "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups_users", id: false, force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "user_id", null: false
    t.index ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id"
    t.index ["user_id", "group_id"], name: "index_groups_users_on_user_id_and_group_id"
  end

  create_table "racial_identities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "racial_identities_users", id: false, force: :cascade do |t|
    t.bigint "racial_identity_id"
    t.bigint "user_id"
    t.index ["racial_identity_id"], name: "index_racial_identities_users_on_racial_identity_id"
    t.index ["user_id"], name: "index_racial_identities_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "uid"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.integer "gender"
    t.integer "age"
    t.integer "zip_code"
    t.boolean "is_hispanic_or_latino"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "federal_assistances_users", "federal_assistances"
  add_foreign_key "federal_assistances_users", "users"
  add_foreign_key "racial_identities_users", "racial_identities"
  add_foreign_key "racial_identities_users", "users"
end
