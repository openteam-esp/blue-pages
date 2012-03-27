class ChangeInfoPathTypeToText < ActiveRecord::Migration
  def change
    change_column :categories, :info_path, :text
    change_column :items, :info_path, :text
    change_column :persons, :info_path, :text
  end
end
