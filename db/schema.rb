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

ActiveRecord::Schema.define(version: 20171013091250) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "email_tracking_events", force: :cascade do |t|
    t.integer  "email_id"
    t.string   "event"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "emails", force: :cascade do |t|
    t.json     "options"
    t.json     "recipient",                null: false
    t.integer  "event_id"
    t.string   "sent_to"
    t.datetime "sent_at"
    t.string   "mailgun_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "lock_version", default: 0
    t.integer  "template_id",              null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "event",         null: false
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "type",          null: false
    t.json     "body",          null: false
    t.string   "job_id"
    t.datetime "processed_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "templates", force: :cascade do |t|
    t.string   "name"
    t.boolean  "show_footer"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["name"], name: "index_templates_on_name", unique: true, using: :btree
  end

  add_foreign_key "emails", "templates"
end
