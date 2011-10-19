class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :surname
      t.string :name
      t.string :patronymic
      t.date :birthdate
      t.references :item

      t.timestamps
    end
    add_index :people, :item_id
  end
end
