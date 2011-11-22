class CategoriesController < ApplicationController
  inherit_resources

  actions :index, :show

  layout "public/main"

  respond_to :html, :json

  def show
    show! do |success|
      @category.expand = true if params[:expand]

      success.json { render :json => @category.to_json }
    end
  end

  def current_ability
    @current_ability ||= AdminAbility.new(current_admin_user)
  end
end
