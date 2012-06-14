class AddFieldsToInnorganization < ActiveRecord::Migration
  def change
    add_column :categories, :status, :text
    add_column :categories, :sphere, :text
    add_column :categories, :university, :text
    add_column :categories, :production, :text
  end
end
