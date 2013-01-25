class AddDossieToPeople < ActiveRecord::Migration
  def up
    add_column :people, :dossier, :text
    StorageInfoPath::Migrator.new(Person).migrate
  end

  def down
    remove_column :people, :dossier
  end
end
