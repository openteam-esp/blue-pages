class ChangeStringToTextAtItem < ActiveRecord::Migration
  def up
    change_column :items, :title, :text
  end

  def down
    change_column :items, :title, :string
  end
end
