class Admin::ItemsController < Admin::ApplicationController
  belongs_to :subdivision

  def destroy
    destroy! { admin_subdivision_path(@subdivision) }
  end
end
