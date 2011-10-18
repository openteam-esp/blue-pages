class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :postcode
      t.string :region
      t.string :district
      t.string :locality
      t.string :street
      t.string :house
      t.string :building
      t.string :flat
      t.references :addressable, :polymorphic => true

      t.timestamps
    end
  end
end
