class AddModeToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :mode, :text
  end
end
