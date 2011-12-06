class AddInfoPathToSubdivisionAndPerson < ActiveRecord::Migration
  def change
    add_column :people, :info_path, :string
    add_column :categories, :info_path, :string
  end
end
