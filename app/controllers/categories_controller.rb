class CategoriesController < ApplicationController
  inherit_resources

  actions :show

  layout "public/main"

  def current_ability
    @current_ability ||= AdminAbility.new(current_admin_user)
  end
end
