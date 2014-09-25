class AddAppointmentsToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :appointments, :text
  end
end
