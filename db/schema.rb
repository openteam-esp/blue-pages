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

ActiveRecord::Schema.define(:version => 20111215111111) do

  create_table "addresses", :force => true do |t|
    t.string   "postcode"
    t.string   "region"
    t.string   "district"
    t.string   "locality"
    t.string   "street"
    t.string   "house"
    t.string   "building"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "office"
  end

  create_table "categories", :force => true do |t|
    t.text     "title"
    t.string   "abbr"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.integer  "position"
    t.text     "url"
    t.string   "type"
    t.string   "weight"
    t.string   "info_path"
    t.integer  "ancestry_depth", :default => 0
  end

  add_index "categories", ["ancestry"], :name => "index_subdivisions_on_ancestry"

  create_table "categories_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "category_id"
  end

  create_table "emails", :force => true do |t|
    t.string   "address"
    t.integer  "emailable_id"
    t.string   "emailable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "emails", ["emailable_id"], :name => "index_emails_on_emailable_id"

  create_table "items", :force => true do |t|
    t.string   "title"
    t.integer  "subdivision_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.string   "weight"
  end

  add_index "items", ["subdivision_id"], :name => "index_items_on_subdivision_id"

  create_table "people", :force => true do |t|
    t.string   "surname"
    t.string   "name"
    t.string   "patronymic"
    t.date     "birthdate"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "info_path"
  end

  add_index "people", ["item_id"], :name => "index_people_on_item_id"

  create_table "phones", :force => true do |t|
    t.string   "code"
    t.string   "number"
    t.integer  "phoneable_id"
    t.string   "phoneable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kind"
    t.string   "additional_number"
  end

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
    t.integer  "sign_in_count",      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["uid"], :name => "index_users_on_uid"

end
