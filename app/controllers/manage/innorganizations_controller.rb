class Manage::InnorganizationsController < Manage::ApplicationController
  belongs_to :category, :optional => true

  def create
    create! { |success, failure|
      success.html { redirect_to manage_innorganization_path(@innorganization) }
    }
  end

  def destroy
    destroy! { manage_category_path(@innorganization.parent) }
  end

  protected
    def collection_path
      manage_category_innorganizations_path(@category)
    end
end
