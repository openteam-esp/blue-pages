class RenameAdminUserSubdivisionsToAdminUserCategories < ActiveRecord::Migration
  def change
    rename_table :admin_users_subdivisions, :admin_users_categories
    rename_column :admin_users_categories, :subdivision_id, :category_id
  end
end
