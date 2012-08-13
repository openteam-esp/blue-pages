class ChangeStringToTextAtItem < ActiveRecord::Migration
  def up
    change_column :items, :title, :text, :length => nil
  end

  def down
    change_column :items, :title, :string
  end
end
