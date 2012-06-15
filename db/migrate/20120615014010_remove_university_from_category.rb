class RemoveUniversityFromCategory < ActiveRecord::Migration
  def up
    remove_column :categories, :university
  end

  def down
    add_column :categories, :university, :text
  end
end
