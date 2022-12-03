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

ActiveRecord::Schema[7.0].define(version: 2022_12_03_080741) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "cameras", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.bigint "sensor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_cameras_on_name", unique: true
    t.index ["sensor_id"], name: "index_cameras_on_sensor_id"
    t.index ["slug"], name: "index_cameras_on_slug", unique: true
  end

  create_table "recipes", force: :cascade do |t|
    t.integer "film_simulation", default: 0, null: false
    t.integer "dynamic_range", default: 0, null: false
    t.integer "highlights", default: 0, null: false
    t.integer "shadows", default: 0, null: false
    t.integer "color", default: 0, null: false
    t.integer "noise_reduction", default: 0, null: false
    t.integer "sharpening", default: 0, null: false
    t.integer "clarity", default: 0, null: false
    t.integer "grain_roughness", default: 0, null: false
    t.integer "grain_size", default: 0, null: false
    t.integer "color_chrome_effect", default: 0, null: false
    t.integer "color_chrome_effect_blue", default: 0, null: false
    t.integer "white_balance", default: 0, null: false
    t.integer "white_balance_red", default: 0, null: false
    t.integer "white_balance_blue", default: 0, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "name"
    t.bigint "parent_id"
    t.integer "sensor_old"
    t.string "original_author"
    t.string "original_url"
    t.bigint "sensor_id"
    t.index ["parent_id"], name: "index_recipes_on_parent_id"
    t.index ["sensor_id"], name: "index_recipes_on_sensor_id"
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "saves", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_saves_on_recipe_id"
    t.index ["user_id"], name: "index_saves_on_user_id"
  end

  create_table "sensors", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sensors_on_name", unique: true
    t.index ["slug"], name: "index_sensors_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "display_name"
    t.text "bio"
    t.string "reddit_uid"
    t.string "website"
    t.boolean "staff", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reddit_uid"], name: "index_users_on_reddit_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cameras", "sensors"
  add_foreign_key "recipes", "recipes", column: "parent_id"
  add_foreign_key "recipes", "sensors"
  add_foreign_key "recipes", "users"
  add_foreign_key "saves", "recipes"
  add_foreign_key "saves", "users"
end
