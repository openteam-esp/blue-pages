class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references :context
      t.references :user
      t.string :role
      t.timestamps
    end
  end
end
