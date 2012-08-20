class AddSomeFieldsToPerson < ActiveRecord::Migration
  def change
    add_column :people, :academic_degree, :text
    add_column :people, :academic_rank, :text
  end
end
