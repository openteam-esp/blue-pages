class DropCategoriesUsers < ActiveRecord::Migration
  def up
    drop_table :categories_users
  end

  def down
    create_table "categories_users", :id => false, :force => true do |t|
      t.integer "user_id"
      t.integer "category_id"
    end

    add_index "categories_users", ["category_id"], :name => "index_categories_users_on_category_id"
    add_index "categories_users", ["user_id"], :name => "index_categories_users_on_user_id"
  end
end
