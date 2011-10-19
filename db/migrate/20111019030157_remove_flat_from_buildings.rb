class RemoveFlatFromBuildings < ActiveRecord::Migration
  def up
    remove_column :buildings, :flat
  end

  def down
    add_column :buildings, :flat, :string
  end
end
