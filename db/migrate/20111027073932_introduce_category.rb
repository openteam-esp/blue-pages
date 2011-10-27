class IntroduceCategory < ActiveRecord::Migration
  def change
    rename_table :subdivisions, :categories
    add_column :categories, :type, :string
  end
end
