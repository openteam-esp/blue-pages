class AddAncestryToSubdivisions < ActiveRecord::Migration
  def up
    add_column :subdivisions, :ancestry, :string
    add_index :subdivisions, :ancestry
  end

  def down
    remove_index :subdivisions, :ancestry
    remove_column :subdivisions, :ancestry
  end
end
