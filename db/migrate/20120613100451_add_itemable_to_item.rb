class AddItemableToItem < ActiveRecord::Migration
  def change
    rename_column :items, :subdivision_id, :itemable_id
    add_column :items, :itemable_type, :string
  end
end
