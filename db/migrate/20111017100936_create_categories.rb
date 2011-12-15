class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string   :type
      t.text     :title
      t.string   :abbr
      t.text     :url
      t.string   :info_path
      t.integer  :position
      t.string   :weight
      t.string   :ancestry
      t.integer  :ancestry_depth
      t.timestamps
    end
    add_index :categories, :ancestry
    add_index :categories, :weight
    add_index :categories, :position
  end
end
