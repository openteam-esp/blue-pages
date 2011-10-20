class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :address
      t.references :emailable, :polymorphic => true

      t.timestamps
    end
    add_index :emails, :emailable_id
  end
end
