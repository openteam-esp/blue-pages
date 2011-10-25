class ChangeTitleTypeOffSubdivisions < ActiveRecord::Migration
  def change
    change_column :subdivisions, :title, :text
  end
end
