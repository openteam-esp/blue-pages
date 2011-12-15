class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.references  :phoneable, :polymorphic => true
      t.string      :kind
      t.string      :code
      t.string      :number
      t.string      :additional_number
      t.timestamps
    end
    add_index :phones, :phoneable_id
  end
end
