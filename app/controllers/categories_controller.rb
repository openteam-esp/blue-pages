class CategoriesController < ApplicationController
  inherit_resources

  actions :index, :show

  layout "public/main"

  respond_to :html, :json

  def show
    show! do |success|
      success.json { render :json => @category.to_json(params[:expand], params[:sync]) }
    end
  end

  def index
    index! do | success |
      success.json { render :json => {:categories => @categories.map{|c| {:id => c.id, :title => ['-' * c.depth, c.title].join(' ')}}} }
    end
  end
end
