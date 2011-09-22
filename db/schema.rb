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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110922184651) do

  create_table "assignments", :force => true do |t|
    t.integer  "number_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
  end

  add_index "assignments", ["group_id"], :name => "index_assignments_on_group_id"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number_id"
    t.integer  "creator_id"
  end

  add_index "groups", ["number_id"], :name => "index_groups_on_number_id"

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recipient",      :limit => 8
    t.integer  "api_message_id", :limit => 8
    t.integer  "from",           :limit => 8
    t.string   "origin"
    t.datetime "timestamps"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "api_timestamp"
    t.string   "network"
    t.integer  "group_id"
  end

  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "notifications", :force => true do |t|
    t.string   "purpose"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "numbers", :force => true do |t|
    t.integer  "inbound_num", :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "panels", :force => true do |t|
    t.boolean  "sending"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "signup"
    t.integer  "max_messages"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.integer  "number",             :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin"
    t.boolean  "registered"
    t.integer  "group_id"
    t.integer  "number_id"
    t.string   "signup_source"
  end

  add_index "users", ["number"], :name => "index_users_on_number", :unique => true
  add_index "users", ["number_id"], :name => "index_users_on_number_id"

end
