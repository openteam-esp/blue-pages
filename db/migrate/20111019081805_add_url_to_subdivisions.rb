class AddUrlToSubdivisions < ActiveRecord::Migration
  def change
    add_column :subdivisions, :url, :text
  end
end
