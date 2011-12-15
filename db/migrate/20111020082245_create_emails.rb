class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.references  :emailable, :polymorphic => true
      t.string      :address
      t.timestamps
    end

    add_index :emails, :emailable_id
  end
end
