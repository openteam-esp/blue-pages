class AddReceptionAndAppointmentsToPerson < ActiveRecord::Migration
  def change
    add_column :people, :reception, :text
    add_column :people, :appointments, :text
  end
end
