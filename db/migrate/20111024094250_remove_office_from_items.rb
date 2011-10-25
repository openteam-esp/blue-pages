class RemoveOfficeFromItems < ActiveRecord::Migration
  def up
    remove_column :items, :office
  end

  def down
    add_column :items, :office, :string
  end
end
