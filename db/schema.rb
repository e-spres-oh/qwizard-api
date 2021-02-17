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

ActiveRecord::Schema.define(version: 2021_02_17_223615) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.string "title"
    t.boolean "is_correct", default: false
    t.bigint "question_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "lobbies", force: :cascade do |t|
    t.string "code"
    t.integer "status"
    t.integer "current_question_index", default: 1
    t.bigint "quiz_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["quiz_id"], name: "index_lobbies_on_quiz_id"
  end

  create_table "player_answers", force: :cascade do |t|
    t.bigint "player_id"
    t.bigint "answer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["answer_id"], name: "index_player_answers_on_answer_id"
    t.index ["player_id"], name: "index_player_answers_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.integer "hat"
    t.bigint "lobby_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lobby_id"], name: "index_players_on_lobby_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "title"
    t.integer "time_limit"
    t.integer "points"
    t.integer "answer_type"
    t.integer "order"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "quiz_id"
    t.index ["quiz_id"], name: "index_questions_on_quiz_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_quizzes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password"
    t.integer "hat"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "lobbies", "quizzes"
  add_foreign_key "player_answers", "answers"
  add_foreign_key "player_answers", "players"
  add_foreign_key "players", "lobbies"
  add_foreign_key "questions", "quizzes"
  add_foreign_key "quizzes", "users"
end
