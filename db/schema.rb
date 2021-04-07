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

ActiveRecord::Schema.define(version: 2021_04_06_201541) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.string "title"
    t.boolean "is_correct"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "question_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "lobbies", force: :cascade do |t|
    t.string "code"
    t.integer "current_question_index"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "quiz_id"
    t.index ["quiz_id"], name: "index_lobbies_on_quiz_id"
  end

  create_table "player_answers", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "player_id"
    t.bigint "answer_id"
    t.index ["answer_id"], name: "index_player_answers_on_answer_id"
    t.index ["player_id"], name: "index_player_answers_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.integer "hat"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "lobby_id"
    t.index ["lobby_id"], name: "index_players_on_lobby_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "title"
    t.integer "answer_type"
    t.integer "order"
    t.integer "points"
    t.integer "time_limit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "quiz_id"
    t.index ["quiz_id"], name: "index_questions_on_quiz_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "lobbies", "quizzes"
  add_foreign_key "player_answers", "answers"
  add_foreign_key "player_answers", "players"
  add_foreign_key "players", "lobbies"
  add_foreign_key "questions", "quizzes"
end
