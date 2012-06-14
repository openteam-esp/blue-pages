class Manage::ItemsController < Manage::ApplicationController
  belongs_to :subdivision, :polymorphic => true, :optional => true
  belongs_to :innorganization, :polymorphic => true, :optional => true

  def destroy
    destroy! { manage_subdivision_path(@subdivision) }
  end

  def sort
    index! do
      params[:ids].each_with_index do |id, index|
        item = Item.find(id)
        item.update_attribute(:position, index.to_i + 1)
      end

      render :nothing => true, :status => 200 and return
    end

  end
end
