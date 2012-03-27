class ChangeInfoPathTypeToText < ActiveRecord::Migration
  def change
    change_column :categories, :info_path, :text
    change_column :people, :info_path, :text
  end
end
