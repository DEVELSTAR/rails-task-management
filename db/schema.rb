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

ActiveRecord::Schema[8.0].define(version: 2025_08_11_113840) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

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

  create_table "addresses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "line1"
    t.string "line2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
  end

  create_table "assessment_answers", force: :cascade do |t|
    t.bigint "assessment_question_id", null: false
    t.text "answer_text", null: false
    t.boolean "is_correct", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assessment_question_id"], name: "index_assessment_answers_on_assessment_question_id"
  end

  create_table "assessment_questions", force: :cascade do |t|
    t.bigint "assessment_id", null: false
    t.text "question_text"
    t.text "explanation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assessment_id"], name: "index_assessment_questions_on_assessment_id"
  end

  create_table "assessments", force: :cascade do |t|
    t.string "assessable_type", null: false
    t.bigint "assessable_id", null: false
    t.string "title"
    t.text "instructions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assessable_type", "assessable_id"], name: "index_assessments_on_assessable"
  end

  create_table "cat_facts", force: :cascade do |t|
    t.string "fact", null: false
    t.string "source", default: "catfact.ninja"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "course_modules", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "position"
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_modules_on_course_id"
  end

  create_table "course_packages", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "package_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_packages_on_course_id"
    t.index ["package_id"], name: "index_course_packages_on_package_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "duration"
    t.string "slug"
    t.decimal "price"
    t.integer "status", default: 0
    t.string "language"
    t.integer "level", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "course_modules_count"
    t.integer "user_course_enrollments_count"
  end

  create_table "lesson_contents", force: :cascade do |t|
    t.bigint "lesson_id", null: false
    t.integer "content_type", default: 0
    t.jsonb "content_data"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_lesson_contents_on_lesson_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "position"
    t.bigint "course_module_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_module_id"], name: "index_lessons_on_course_module_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_id"
    t.string "notification_type", null: false
    t.boolean "read", default: false
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_notifications_on_course_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.decimal "price"
    t.decimal "discount"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "quran_verses", force: :cascade do |t|
    t.string "surah_name"
    t.string "verse_number"
    t.text "text"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "language"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "todo"
    t.date "due_date"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "user_assessment_results", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "assessment_id", null: false
    t.integer "score", default: 0
    t.boolean "passed"
    t.datetime "attempted_at"
    t.jsonb "answers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assessment_id"], name: "index_user_assessment_results_on_assessment_id"
    t.index ["user_id"], name: "index_user_assessment_results_on_user_id"
  end

  create_table "user_course_enrollments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_id", null: false
    t.integer "status", default: 0
    t.integer "progress", default: 0
    t.datetime "enrolled_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_user_course_enrollments_on_course_id"
    t.index ["user_id"], name: "index_user_course_enrollments_on_user_id"
  end

  create_table "user_lesson_statuses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "lesson_id", null: false
    t.integer "status"
    t.integer "score"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_user_lesson_statuses_on_lesson_id"
    t.index ["user_id"], name: "index_user_lesson_statuses_on_user_id"
  end

  create_table "user_package_purchases", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "package_id", null: false
    t.datetime "purchased_at"
    t.datetime "expires_at"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["package_id"], name: "index_user_package_purchases_on_package_id"
    t.index ["user_id"], name: "index_user_package_purchases_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_course_enrollments_count"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "users"
  add_foreign_key "assessment_answers", "assessment_questions"
  add_foreign_key "assessment_questions", "assessments"
  add_foreign_key "course_modules", "courses"
  add_foreign_key "course_packages", "courses"
  add_foreign_key "course_packages", "packages"
  add_foreign_key "lesson_contents", "lessons"
  add_foreign_key "lessons", "course_modules"
  add_foreign_key "notifications", "courses"
  add_foreign_key "notifications", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "tasks", "users"
  add_foreign_key "user_assessment_results", "assessments"
  add_foreign_key "user_assessment_results", "users"
  add_foreign_key "user_course_enrollments", "courses"
  add_foreign_key "user_course_enrollments", "users"
  add_foreign_key "user_lesson_statuses", "lessons"
  add_foreign_key "user_lesson_statuses", "users"
  add_foreign_key "user_package_purchases", "packages"
  add_foreign_key "user_package_purchases", "users"
end
