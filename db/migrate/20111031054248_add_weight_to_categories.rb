class AddWeightToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :weight, :string
  end
end
