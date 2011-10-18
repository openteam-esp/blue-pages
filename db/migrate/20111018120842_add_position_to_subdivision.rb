class AddPositionToSubdivision < ActiveRecord::Migration
  def change
    add_column :subdivisions, :position, :integer
  end
end
