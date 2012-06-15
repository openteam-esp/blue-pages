class AddImageUrlToInnorganization < ActiveRecord::Migration
  def change
    add_column :categories, :image_url, :text

  end
end
