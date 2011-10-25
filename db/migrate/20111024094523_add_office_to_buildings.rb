class AddOfficeToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :office, :string
  end
end
