class CreateCategoriesUsers < ActiveRecord::Migration
  def change
    create_table :categories_users, :id => false do |t|
      t.references :user
      t.references :category
    end
    add_index :categories_users, :category_id
    add_index :categories_users, :user_id
  end
end
