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

ActiveRecord::Schema[8.0].define(version: 2025_08_08_053723) do
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

  create_table "admin_users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
  end

  create_table "assessment_questions", force: :cascade do |t|
    t.bigint "lesson_assessment_id", null: false
    t.text "question_text"
    t.jsonb "options"
    t.string "correct_option"
    t.text "explanation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "final_assessment_id"
    t.index ["final_assessment_id"], name: "index_assessment_questions_on_final_assessment_id"
    t.index ["lesson_assessment_id"], name: "index_assessment_questions_on_lesson_assessment_id"
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
    t.string "image"
    t.decimal "price"
    t.integer "status", default: 0
    t.string "language"
    t.integer "level", default: 0
    t.boolean "is_published"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "final_assessments", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.string "title"
    t.text "instructions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_final_assessments_on_course_id"
  end

  create_table "lesson_assessments", force: :cascade do |t|
    t.bigint "lesson_id", null: false
    t.string "title"
    t.text "instructions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_lesson_assessments_on_lesson_id"
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
    t.bigint "course_id", null: false
    t.bigint "course_module_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_lessons_on_course_id"
    t.index ["course_module_id"], name: "index_lessons_on_course_module_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.decimal "price"
    t.decimal "discount"
    t.integer "duration"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.bigint "lesson_assessment_id", null: false
    t.bigint "final_assessment_id", null: false
    t.integer "score", default: 0
    t.boolean "passed"
    t.datetime "attempted_at"
    t.jsonb "answers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["final_assessment_id"], name: "index_user_assessment_results_on_final_assessment_id"
    t.index ["lesson_assessment_id"], name: "index_user_assessment_results_on_lesson_assessment_id"
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
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "assessment_questions", "final_assessments"
  add_foreign_key "assessment_questions", "lesson_assessments"
  add_foreign_key "course_modules", "courses"
  add_foreign_key "course_packages", "courses"
  add_foreign_key "course_packages", "packages"
  add_foreign_key "final_assessments", "courses"
  add_foreign_key "lesson_assessments", "lessons"
  add_foreign_key "lesson_contents", "lessons"
  add_foreign_key "lessons", "course_modules"
  add_foreign_key "lessons", "courses"
  add_foreign_key "tasks", "users"
  add_foreign_key "user_assessment_results", "final_assessments"
  add_foreign_key "user_assessment_results", "lesson_assessments"
  add_foreign_key "user_assessment_results", "users"
  add_foreign_key "user_course_enrollments", "courses"
  add_foreign_key "user_course_enrollments", "users"
  add_foreign_key "user_lesson_statuses", "lessons"
  add_foreign_key "user_lesson_statuses", "users"
  add_foreign_key "user_package_purchases", "packages"
  add_foreign_key "user_package_purchases", "users"
end
