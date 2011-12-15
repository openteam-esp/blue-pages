class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references  :subdivision
      t.string      :title
      t.integer     :position
      t.string      :weight
      t.timestamps
    end

    add_index :items, :subdivision_id
    add_index :items, :weight
    add_index :items, :position
  end
end
