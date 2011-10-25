class MoveOfficeFromBuildingsToItemsAndSubdivisions < ActiveRecord::Migration
  def up
    remove_column :buildings, :office
    add_column :items, :office, :string
    add_column :subdivisions, :office, :string
  end

  def down
    remove_column :subdivisions, :office
    remove_column :items, :office
    add_column :buildings, :office, :string
  end
end
