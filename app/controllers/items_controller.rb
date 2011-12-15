class ItemsController < ApplicationController
  inherit_resources

  actions :show

  belongs_to :category

  layout "public/main"

  def show
    show! do |success|
      success.json { render :json => @item.to_json }
    end
  end
end
