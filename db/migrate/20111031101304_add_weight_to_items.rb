class AddWeightToItems < ActiveRecord::Migration
  def change
    add_column :items, :weight, :string
  end
end
