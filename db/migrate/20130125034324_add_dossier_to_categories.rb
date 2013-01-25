class AddDossierToCategories < ActiveRecord::Migration
  def up
    add_column :categories, :dossier, :text
    StorageInfoPath::Migrator.new(Category).migrate
  end

  def down
    remove_column :categories, :dossier
  end
end
