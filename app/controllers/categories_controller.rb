class CategoriesController < ApplicationController
  inherit_resources

  actions :index, :show

  layout "public/main"

  respond_to :html, :json

  def current_ability
    @current_ability ||= AdminAbility.new(current_admin_user)
  end
end
