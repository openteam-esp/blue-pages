class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :code
      t.string :number
      t.references :phoneable, :polymorphic => true

      t.timestamps
    end
  end
end
