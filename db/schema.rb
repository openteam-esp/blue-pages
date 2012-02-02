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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120201171055) do

  create_table "addresses", :force => true do |t|
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.string   "postcode"
    t.string   "region"
    t.string   "district"
    t.string   "locality"
    t.string   "street"
    t.string   "house"
    t.string   "building"
    t.string   "office"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "addresses", ["addressable_id"], :name => "index_addresses_on_addressable_id"

  create_table "categories", :force => true do |t|
    t.string   "type"
    t.text     "title"
    t.string   "abbr"
    t.text     "url"
    t.string   "info_path"
    t.integer  "position"
    t.string   "weight"
    t.string   "ancestry"
    t.integer  "ancestry_depth"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "categories", ["ancestry"], :name => "index_categories_on_ancestry"
  add_index "categories", ["position"], :name => "index_categories_on_position"
  add_index "categories", ["weight"], :name => "index_categories_on_weight"

  create_table "emails", :force => true do |t|
    t.integer  "emailable_id"
    t.string   "emailable_type"
    t.string   "address"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "emails", ["emailable_id"], :name => "index_emails_on_emailable_id"

  create_table "items", :force => true do |t|
    t.integer  "subdivision_id"
    t.string   "title"
    t.integer  "position"
    t.string   "weight"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "items", ["position"], :name => "index_items_on_position"
  add_index "items", ["subdivision_id"], :name => "index_items_on_subdivision_id"
  add_index "items", ["weight"], :name => "index_items_on_weight"

  create_table "people", :force => true do |t|
    t.integer  "item_id"
    t.string   "surname"
    t.string   "name"
    t.string   "patronymic"
    t.date     "birthdate"
    t.string   "info_path"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "people", ["item_id"], :name => "index_people_on_item_id"

  create_table "permissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "context_id"
    t.string   "context_type"
    t.string   "role"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "permissions", ["user_id", "role", "context_id", "context_type"], :name => "by_user_and_role_and_context"

  create_table "phones", :force => true do |t|
    t.integer  "phoneable_id"
    t.string   "phoneable_type"
    t.string   "kind"
    t.string   "code"
    t.string   "number"
    t.string   "additional_number"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "phones", ["phoneable_id"], :name => "index_phones_on_phoneable_id"

  create_table "users", :force => true do |t|
    t.string   "uid"
    t.text     "name"
    t.text     "email"
    t.text     "nickname"
    t.text     "first_name"
    t.text     "last_name"
    t.text     "location"
    t.text     "description"
    t.text     "image"
    t.text     "phone"
    t.text     "urls"
    t.text     "raw_info"
    t.integer  "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "users", ["uid"], :name => "index_users_on_uid"

end
