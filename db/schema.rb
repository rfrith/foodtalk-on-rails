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

ActiveRecord::Schema.define(version: 20171108172424) do

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "federal_assistances", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "federal_assistances_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "federal_assistance_id", null: false
  end

  create_table "glossary_terms", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "source"
    t.string "image_remote_origin"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ingredients", force: :cascade do |t|
    t.integer "recipe_id"
    t.float "quantity"
    t.string "unit_of_measure"
    t.string "name"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_ingredients_on_recipe_id"
  end

  create_table "racial_identities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "racial_identities_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "racial_identity_id", null: false
  end

  create_table "recipe_categorizations", force: :cascade do |t|
    t.integer "recipe_id"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipe_glossary_terms", force: :cascade do |t|
    t.integer "recipe_id"
    t.integer "glossary_term_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipes", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "instructions"
    t.text "notes"
    t.string "source"
    t.string "source_url"
    t.string "image"
    t.integer "yield"
    t.string "yield_unit"
    t.integer "prep_time"
    t.integer "cooking_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
  end

  create_table "videos", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "video_id"
    t.string "redirect_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
