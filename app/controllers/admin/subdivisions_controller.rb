class Admin::SubdivisionsController < Admin::ApplicationController
  belongs_to :category, :optional => true

  def create
    create! { admin_subdivision_path(@subdivision) }
  end

  def destroy
    destroy! { admin_category_path(@subdivision.parent) }
  end

  protected
    def collection_path
      admin_category_subdivisions_path(@category)
    end
end
