class AddKindToPhones < ActiveRecord::Migration
  def change
    add_column :phones, :kind, :string
  end
end
