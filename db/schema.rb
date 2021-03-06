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

ActiveRecord::Schema.define(:version => 20140925094726) do

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

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         :default => 0
    t.string   "comment"
    t.string   "remote_address"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], :name => "associated_index"
  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "categories", :force => true do |t|
    t.string   "type"
    t.text     "title"
    t.string   "abbr"
    t.text     "url"
    t.text     "info_path"
    t.integer  "position"
    t.string   "weight"
    t.string   "ancestry"
    t.integer  "ancestry_depth"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "kind"
    t.text     "status"
    t.text     "sphere"
    t.text     "production"
    t.text     "image_url"
    t.string   "slug"
    t.text     "dossier"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "mode"
    t.text     "appointments"
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
    t.integer  "itemable_id"
    t.text     "title"
    t.integer  "position"
    t.string   "weight"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_url"
    t.string   "itemable_type"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "items", ["itemable_id"], :name => "index_items_on_subdivision_id"
  add_index "items", ["position"], :name => "index_items_on_position"
  add_index "items", ["weight"], :name => "index_items_on_weight"

  create_table "people", :force => true do |t|
    t.integer  "item_id"
    t.string   "surname"
    t.string   "name"
    t.string   "patronymic"
    t.date     "birthdate"
    t.text     "info_path"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "academic_degree"
    t.text     "academic_rank"
    t.text     "dossier"
    t.text     "reception"
    t.text     "appointments"
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
