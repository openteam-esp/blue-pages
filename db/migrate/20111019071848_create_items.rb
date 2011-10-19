class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.references :subdivision

      t.timestamps
    end
    add_index :items, :subdivision_id
  end
end
