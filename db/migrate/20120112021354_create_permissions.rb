class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.references :context, :polymorphic => true
      t.references :user
      t.string :role
      t.timestamps
    end
  end
end
