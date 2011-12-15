class CategoriesController < ApplicationController
  inherit_resources

  actions :index, :show

  layout "public/main"

  respond_to :html, :json

  def show
    show! do |success|
      success.json { render :json => @category.to_json(params[:expand]) }
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end
end
