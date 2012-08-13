class ChangeInfoPathTypeToText < ActiveRecord::Migration
  def change
    change_column :categories, :info_path, :text, :length => nil
    change_column :people, :info_path, :text, :length => nil
  end
end
