class AddOfficeToItems < ActiveRecord::Migration
  def change
    add_column :items, :office, :string
  end
end
