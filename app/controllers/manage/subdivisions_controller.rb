class Manage::SubdivisionsController < Manage::ApplicationController
  belongs_to :category, :optional => true

  def create
    create! { |success, failure|
      success.html { redirect_to manage_subdivision_path(@subdivision) }
    }
  end

  def destroy
    destroy! { manage_category_path(@subdivision.parent) }
  end

  protected
    def collection_path
      manage_category_subdivisions_path(@category)
    end
end
