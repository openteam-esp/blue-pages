class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people, :force => true do |t|
      t.references  :item
      t.string      :surname
      t.string      :name
      t.string      :patronymic
      t.date        :birthdate
      t.string      :info_path
      t.timestamps
    end

    add_index :people, :item_id
  end
end
