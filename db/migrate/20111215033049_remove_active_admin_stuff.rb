class RemoveActiveAdminStuff < ActiveRecord::Migration
  def change
    rename_table :admin_users_categories, :categories_users
    rename_column :categories_users, :admin_user_id, :user_id
    drop_table :active_admin_comments
    drop_table :admin_users
  end
end
