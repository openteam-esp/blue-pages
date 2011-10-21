class AddAdditionalNumberToPhones < ActiveRecord::Migration
  def change
    add_column :phones, :additional_number, :string
  end
end
