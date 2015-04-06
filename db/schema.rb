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

ActiveRecord::Schema.define(version: 20150112004353) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agent_deals", force: :cascade do |t|
    t.integer  "agent_id"
    t.integer  "deal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "agent_deals", ["agent_id"], name: "index_agent_deals_on_agent_id", using: :btree
  add_index "agent_deals", ["deal_id"], name: "index_agent_deals_on_deal_id", using: :btree

  create_table "agents", force: :cascade do |t|
    t.integer  "balance",    default: 20000
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "deals", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "trade_date_id"
    t.date     "due_date"
    t.integer  "open_price"
    t.integer  "close_price"
    t.integer  "final_price"
    t.string   "due_type"
  end

  add_index "deals", ["trade_date_id"], name: "index_deals_on_trade_date_id", using: :btree

  create_table "trade_dates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date     "trade_date"
  end

end
