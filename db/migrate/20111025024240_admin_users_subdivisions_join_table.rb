class AdminUsersSubdivisionsJoinTable < ActiveRecord::Migration
  def change
    create_table :admin_users_subdivisions, :id => false do |t|
      t.integer :admin_user_id
      t.integer :subdivision_id
    end
  end
end
