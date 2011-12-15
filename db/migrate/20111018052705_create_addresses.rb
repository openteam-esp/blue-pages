class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references  :addressable, :polymorphic => true
      t.string      :postcode
      t.string      :region
      t.string      :district
      t.string      :locality
      t.string      :street
      t.string      :house
      t.string      :building
      t.string      :office
      t.timestamps
    end
    add_index :addresses, :addressable_id
  end
end
