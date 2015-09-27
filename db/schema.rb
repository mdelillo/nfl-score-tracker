# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150927153740) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.string   "game_center_id"
    t.boolean  "ended",           default: false
    t.string   "home_team"
    t.string   "away_team"
    t.integer  "home_team_score"
    t.integer  "away_team_score"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "score_events", force: :cascade do |t|
    t.string   "game_center_id"
    t.string   "team_name"
    t.string   "type"
    t.string   "description"
    t.integer  "game_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "score_events", ["game_id"], name: "index_score_events_on_game_id", using: :btree

  add_foreign_key "score_events", "games"
end
