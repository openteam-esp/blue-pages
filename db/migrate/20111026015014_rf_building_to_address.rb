class RfBuildingToAddress < ActiveRecord::Migration
  def up
    remove_column :items, :office
    remove_column :subdivisions, :office

    rename_table :buildings, :addresses
    add_column :addresses, :office, :string
  end

  def down
    remove_column :addresses, :office
    rename_table :addresses, :buildings

    add_column :subdivisions, :office, :string
    add_column :items, :office, :string
  end
end
