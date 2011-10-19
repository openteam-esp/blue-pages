class RenameAddressToBuilding < ActiveRecord::Migration
  def change
    rename_table :addresses, :buildings
  end
end
